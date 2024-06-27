
FROM python:3.9-slim

WORKDIR /app

COPY . /app

EXPOSE 5000

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_APP=main.py

CMD ["flask", "run", "--host=0.0.0.0"]