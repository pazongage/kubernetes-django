FROM python:3.12.5-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the poetry configuration and lock files before installing dependencies
COPY ./pyproject.toml ./poetry.lock /app/

# Install Poetry
RUN pip install --upgrade pip \
    && pip install poetry

# Install dependencies using Poetry
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Now copy the rest of the application files (including ./web)
COPY ./web /app/

# Copy and set permissions for the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the port the app will use
EXPOSE 8000

# Use the entrypoint script to run the app
ENTRYPOINT [ "sh", "/entrypoint.sh" ]
