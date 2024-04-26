# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port Flask is running on
EXPOSE 5000
# Define environment variable
ENV FLASK_APP app.py

# Run app.py when the container launches
CMD ["flask", "run", "--host=0.0.0.0"]
