# Use a base image with Python and Tkinter pre-installed
FROM python:latest

# Set the working directory in the container
WORKDIR /alphazero

# Copy the Python script and other necessary files
COPY  alphazero.py ./
COPY . .



# Expose port for the web server (assuming your Python script serves on port 80)
EXPOSE 80

# Run the Python script and start a simple web server
CMD ["python", "alphazero.py"]

# Add a command to open the default web browser after running the Python script
CMD ["python", "-m", "webbrowser", "http://localhost:3000"]