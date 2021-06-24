FROM python:3.7.10
ENV DEBIAN_FRONTEND=noninteractive 

WORKDIR /app
COPY . .
RUN mkdir -p ~/.insightface/
RUN mv models ~/.insightface/

RUN apt update
RUN apt install ffmpeg libsm6 libxext6  -y
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install -r requirements.txt
RUN cd python-package && pip install . && cd ..

CMD ["python3.7", "app.py","--gpu-id", "-1"]