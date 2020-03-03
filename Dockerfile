FROM python:3.4-alpine
ADD ./proj/src/sampleapp.py /code/sampleapp.py
ADD ./proj/requirements.txt /code/requirements.txt
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "sampleapp.py"]

