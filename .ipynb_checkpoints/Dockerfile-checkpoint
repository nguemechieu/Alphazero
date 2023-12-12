

# Use a base image with Python and Tkinter pre-installed
FROM python:latest

# Set the working directory in the container


WORKDIR ./zones
COPY ./zones.py  ./zones.py
COPY . .
# Install required packages
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev && \
    pip install mysqlclient
# Run the Python script
CMD ["python", "zones.py"]