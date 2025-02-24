#Stage One: Builder begins with the first FROM statement
FROM python:3.11-buster as builder
WORKDIR /app
RUN pip install --upgrade pip && pip install poetry
#Copy necessary files
COPY pyproject.toml poetry.lock /app/
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

#Stage two: App begins with the second FROM statement
FROM python:3.11-buster as app
WORKDIR /app
COPY --from=builder /app /app

EXPOSE 8000

ENTRYPOINT /app/entrypoint.sh
CMD uvicorn cc_compose.server:app --reload --host 0.0.0.0 --port 8000
