# ── Stage 1: Dependencies ──────────────────────────────────────────────────────
FROM python:3.12-slim AS deps

WORKDIR /deps

COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ── Stage 2: Production image ─────────────────────────────────────────────────
FROM python:3.12-slim AS production

# Security: non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy pre-built dependencies
COPY --from=deps /install /usr/local

# Copy application source
COPY app/ .

# Drop privileges
USER appuser

EXPOSE 8080

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8080

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "4", "main:app"]
