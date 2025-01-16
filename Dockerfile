FROM python:3.8-slim-buster

WORKDIR /app

# Copy the requirements.txt file
#COPY requirements.txt requirements.txt
#
# # Install the required Python packages
RUN pip3 install flask
#
# # Copy the rest of the application code
COPY . .
#
# # Set the environment variable to specify the Flask app
ENV FLASK_APP=app.py
#
# # Run Flask with the proper command
#CMD ["flask", "run", "--host=0.0.0.0"]
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]

