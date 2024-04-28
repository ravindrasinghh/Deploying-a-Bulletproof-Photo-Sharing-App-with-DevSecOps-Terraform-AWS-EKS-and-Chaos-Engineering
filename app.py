from flask import Flask, request, redirect, render_template, jsonify
import boto3
import uuid
import os
import json
import logging
from werkzeug.utils import secure_filename

app = Flask(__name__, static_url_path='/static')
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

s3 = boto3.client('s3')

# Environment variables
S3_BUCKET = os.getenv('S3_BUCKET', 'default-bucket')
CLOUDFRONT_DOMAIN = os.getenv('CLOUDFRONT_DOMAIN', 'default.cloudfront.net')

# AWS DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='ap-south-1')
table = dynamodb.Table('PhotosMetadata')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    if file:
        original_filename = secure_filename(file.filename)  # Safely secure the filename

        # Upload to S3
        s3.upload_fileobj(file, S3_BUCKET, original_filename)

        # Generate S3 URL
        s3_url = f'https://{S3_BUCKET}.s3.amazonaws.com/{original_filename}'

        # Generate URL from CloudFront
        cloudfront_url = f'https://{CLOUDFRONT_DOMAIN}/{original_filename}'

        # Store metadata in DynamoDB
        table.put_item(
            Item={
                'photo_id': str(uuid.uuid4()),  # Generate a photo ID for internal tracking
                'filename': original_filename,  # Store the original filename in DynamoDB
                's3_url': s3_url,
                'cloudfront_url': cloudfront_url
            }
        )
        logger.info(f"File uploaded successfully. CloudFront URL: {cloudfront_url}")
        download_instructions = f"Please download the file using this link: {cloudfront_url}"

        return jsonify({
            'message': 'File uploaded successfully, processing initiated.',
            'cloudfront_url': cloudfront_url,
            'download_instructions': download_instructions
        })
    else:
        error_message = 'No file part in the request.'
        logger.error(error_message)
        return render_template('index.html', error=error_message), 400

if __name__ == '__main__':
    app.run(debug=True, port=5000)
