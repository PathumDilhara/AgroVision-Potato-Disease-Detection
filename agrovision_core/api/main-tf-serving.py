from fastapi import FastAPI, File, UploadFile
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
import requests
import json


# run the app : uvicorn main-tf-serving:app --reload

app = FastAPI()

# /v1/models/<model_name>:predict
endpoint = "http://localhost:8501/v1/models/potatoes_model:predict"

# Chek wich verison currnly use
# http://localhost:8501/v1/models/potatoes_model


# Run tf serving
'''docker run -t --rm -p 8501:8501 -v "PATH\saved_models:/models" tensorflow/serving --rest_api_port=8501 --model_config_file="/models/models.config"
'''

CLASS_NAMES = json.load(open("class_names.json"))
print(CLASS_NAMES)

@app.get("/ping")
async def ping():
    return "Hello tf-server running"

def read_file_as_image(data) -> np.ndarray:
    image = np.array(Image.open(BytesIO (data)))
    return image

@app.post("/predict")
async def predict(
    file: UploadFile = File(...)
):
    #print(file)
    
    bytes = await file.read()
    #print(bytes)

    image = read_file_as_image(bytes)
    image_batch = np.expand_dims(image, 0)
    
    json_data = {
        "instances": image_batch.tolist()
    }

    print("# IMAGE SHAPE:", image.shape)
    print("# BATCH SHAPE:", image_batch.shape)

    response = requests.post(endpoint, json=json_data)
    print("\n\n",response)

    prediction = response.json()["predictions"][0]
    print("\n\n", prediction)

    # Return index of max value
    index_max = np.argmax(prediction)

    predicted_class = CLASS_NAMES[index_max]
    #print("\npredicted_class : ", predicted_class)

    # predictions[0] may contain 3 values for 3 classes, so max values consuider as confidence
    confidence = np.max(prediction)
    #print("\nconfidence : ", confidence)
    
    print("######", image.min(), image.max())

    return {
        'class' : predicted_class,
        'confidence' : float(confidence)
    }





if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)


