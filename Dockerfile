# Use the official Python image from the Docker Hub
 FROM python:3.9-slim
#
# # Set the working directory in the container
 WORKDIR /app
#
# # Copy the requirements.txt into the container
 COPY requirements.txt .
#
# # Install the dependencies from requirements.txt
 RUN pip install --no-cache-dir -r requirements.txt
#
# # Copy the rest of your application code into the container
 COPY . .
#
# # Expose the port that the Flask app will run on (default is 5000)
 EXPOSE 5000
#
# # Set the environment variable for Flask
 ENV FLASK_APP=app.py
#
# # Run the Flask app (production-ready environment variable)
 CMD ["flask", "run", "--host=0.0.0.0"]
# 
