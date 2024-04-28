from flask import Flask, request, redirect, render_template, jsonify
import boto3
import uuid
import os
import json
import logging
from botocore.exceptions import ClientError


app = Flask(__name__, static_url_path='/static')
# Configure logging
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
        
        photo_id = str(uuid.uuid4())
        # Upload to S3
        s3.upload_fileobj(file, S3_BUCKET, photo_id)


        # Generate S3 URL
        s3_url = f'https://{S3_BUCKET}.s3.amazonaws.com/{photo_id}'

        # Generate URL from CloudFront
        cloudfront_url = f'https://{CLOUDFRONT_DOMAIN}/{photo_id}'

        # Store metadata in DynamoDB
        table.put_item(
            Item={
                'photo_id': photo_id,
                'filename': file.filename,
                's3_url': s3_url,
                'cloudfront_url': cloudfront_url
            }
        )
        # Log successful upload and return response
        logger.info(f"File uploaded successfully. CloudFront URL: {cloudfront_url}")
        # Include download instructions in the response
        download_instructions = f"Please download the file using this link: {cloudfront_url}"

        return jsonify({
            'message': 'File uploaded successfully, processing initiated.',
            'cloudfront_url': cloudfront_url,
            'download_instructions': download_instructions
        })
    return render_template('index.html', error='File upload failed')
    return jsonify({'message': 'File upload failed'}), 400


if __name__ == '__main__':
    app.run(debug=True, port=5000)
