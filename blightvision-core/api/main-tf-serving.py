from fastapi import FastAPI, File, UploadFile
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
import requests

app = FastAPI()

# /v1/models/<model_name>:predict
endpoint = "http://localhost:8501/v1/models/potatoes_model:predict"

CLASS_NAMES = ["Early Blight", "Late Blight", "Healthy"]

@app.get("/ping")
async def ping():
    return "Hello tf-server running"

def read_file_as_image(data) -> np.ndarray:
    image = Image.open(BytesIO (data)).convert("RGB")
    image = image.resize((256, 256))
    image = np.array(image).astype(np.float32) / 255.0
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

    response = requests.post(endpoint, json=json_data)
    print("\n\n",response)

    prediction = response.json()["predictions"][0]
    print("\n\n", prediction)

    # Retuern index of max value
    index_max = np.argmax(prediction)

    predicted_class = CLASS_NAMES[index_max]
    #print("\npredicted_class : ", predicted_class)

    # predictions[0] may contain 3 values for 3 classes, so max values consuider as confidence
    confidence = np.max(prediction)
    #print("\nconfidence : ", confidence)
    
    return {
        'class' : predicted_class,
        'confidence' : float(confidence)
    }





if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)






# ========================== ONLY WITH FASTAPI =========================

'''
from fastapi import FastAPI, File, UploadFile
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf

app = FastAPI()

MODEL = tf.saved_model.load("../saved_models/export/1")
INTER = MODEL.signatures["serving_default"]

CLASS_NAMES = ["Early Blight", "Late Blight", "Healthy"]

@app.get("/ping")
async def ping():
    return "Hello server running"

def read_file_as_image(data) -> np.ndarray:
    image = Image.open(BytesIO (data)).convert("RGB")
    image = image.resize((256, 256))
    image = np.array(image).astype(np.float32) / 255.0
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
    
    # Model expect image batch not a single image so even 1 image put into a batch
    preds  = INTER(tf.constant(image_batch))
    #print("\preds : ", preds)

    predictions = list(preds.values())[0].numpy()
    #print("\predictions : ", predictions)
   

    # Retuern index of max value
    index_max = np.argmax(predictions[0])

    predicted_class = CLASS_NAMES[index_max]
    #print("\npredicted_class : ", predicted_class)

    # predictions[0] may contain 3 values for 3 classes, so max values consuider as confidence
    confidence = np.max(predictions[0])
    #print("\nconfidence : ", confidence)
    
    return {
        'class' : predicted_class,
        'confidence' : float(confidence)
    }





if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)
'''