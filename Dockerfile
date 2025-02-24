#Stage One: Builder begins with the first FROM statement
FROM python:3.11-buster as builder
WORKDIR /app
RUN pip install --upgrade pip && pip install poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=true

#Copy necessary files
COPY pyproject.toml poetry.lock /app/

RUN poetry install --no-root --no-interaction --no-ansi

#Stage two: App begins with the second FROM statement
FROM python:3.11-buster as app
WORKDIR /app

COPY --from=builder /app /app
#COPY entrypoint.sh /entrypoint.sh

EXPOSE 8000
# ENTRYPOINT /entrypoint.sh
ENV PATH="/app/.venv/bin:$PATH"
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]