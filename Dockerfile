FROM python:3.11.0b1-buster

# Set work directory
WORKDIR /app

# Install dependencies for psycopg2
RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev=11.16-0+deb10u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Expose port
EXPOSE 8000

# Run migrations and start Gunicorn
WORKDIR /app
RUN python manage.py migrate
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
