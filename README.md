# Face detection and recognition

[![DOI](https://zenodo.org/badge/358311422.svg)](https://zenodo.org/badge/latestdoi/358311422)

This repo is forked from https://github.com/deepinsight/insightface. I use their face detection ([retinaface](https://paperswithcode.com/paper/190500641)) and face recognition ([arcface](https://paperswithcode.com/paper/arcface-additive-angular-margin-loss-for-deep)).

I used to use their gender and age estimation as well, but the accuracy is very bad so I had to drop it.

I have a new age-gender estimation model. Check out [the repo](https://github.com/tae898/age-gender) and [the demo video](https://youtu.be/Dna_Hp-s78I).

## Flask server.

I made a light-weight flask server that loads the modules and waits for the client calls. 

You can either run the `app.py` directly in Python3 or in a docker container.

Pulling and running the docker containers is easier and recommended.

### Run in a docker container (recommended)

- Pull and run on CPU

    1. Pull the image from docker hub and run the container.
        ```bash
        docker run -it --rm -p 10002:10002 tae898/face-detection-recognition
        ```

    1. Build it (optional)
                
        If you want to build this container from scratch for whatever reason, you can do so.

        Make sure your current directory is the root directory of this repo.

        First download the models and unzip them.

        ```bash
        wget https://github.com/tae898/face-detection-recognition/releases/download/models/models.zip

        unzip models.zip
        ```

        And build it.        
        ```bash
        docker build -t face-detection-recognition .  
        ```

- Pull and run on GPU

    1. Pull the image from docker hub and run the container.
        ```bash
        docker run -it --rm -p 10002:10002 --gpus all tae898/face-detection-recognition-cuda
        ```

    1. Build it (optional)

        If you want to build this container from scratch for whatever reason, you can do so.

        Make sure your current directory is the root directory of this repo.

        First download the models and unzip them.

        ```bash
        wget https://github.com/tae898/face-detection-recognition/releases/download/models/models.zip

        unzip models.zip
        ```

        And build it.        
        ```bash
        docker build -f Dockerfile-cuda -t face-detection-recognition-cuda .  
        ```

### Run directly (CPU only)

First your current directory should be the root directory of this repo.


1. Download the models and unzip them.
    ```bash
    wget https://github.com/tae898/face-detection-recognition/releases/download/models/models.zip

    unzip models.zip

    mkdir -p ~/.insightface/
    mv models ~/.insightface/
    ```

1. Install the requirements.
    ```bash
    pip3 install -r requirements.txt
    ```

2. Install the insightface python package.

    ```bash
    cd python-package && pip install . && cd ..
    ```

3. Run both apps.
    ```bash
    python3 app.py --gpu-id -1
    ```

## Making a REST POST request to the flask server.

You should [send an image as json](https://jsonpickle.github.io/). I know this is not conventional but somehow this works really good. Below is an example code.

```python
import jsonpickle
import requests
import pickle

with open('/path/to/image', 'rb') as stream:
    frame_bytestring = stream.read()
data = {'image': frame_bytestring}
data = jsonpickle.encode(data)
response = requests.post('http://127.0.0.1:10002/', json=data)
response = jsonpickle.decode(response.text)
face_detection_recognition = response['face_detection_recognition']

with open('/path/to/save/results', 'wb') as stream:
    pickle.dump(face_detection_recognition, stream)
```

`face_detection_recognition` is a list of `dict`s. The number of `dict`s correspond to the number of faces detected in the image. Every `dict` has four key-value pairs. They are:

```
bbox: bounding box (four floating point numbers).
det_score: detection confidence score (one floating point)
landmark: five facial landmarks (5 by 2 float array)
normed_embedding: face embedding (512-dimensional floating point vector)
```

## Troubleshooting

The best way to find and solve your problems is to see in the github issue tab. If you can't find what you want, feel free to raise an issue. We are pretty responsive.

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Authors

* [Taewoon Kim](https://taewoon.kim/) 
