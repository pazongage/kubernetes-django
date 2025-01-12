FROM python:3.12.5-slim

WORKDIR /app

COPY ./web /app

RUN pip install --upgrade pip \
    && pip install poetry

COPY ./pyproject.toml ./poetry.lock /app/

RUN poetry config virtualenvs.create false \ 
    && poetry install --no-interaction --no-ansi

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "sh","/entrypoint.sh" ]