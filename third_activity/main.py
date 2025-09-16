import pandas as pd
import matplotlib.pyplot as plt
from fastapi import FastAPI
import joblib
from pydantic import BaseModel
from sklearn.preprocessing import LabelEncoder
import numpy as np
from io import BytesIO
from fastapi.responses import Response

model = joblib.load("modelo_regressao_linear.pkl")
labelEncoder = LabelEncoder()


class Item(BaseModel):
    client_id: int
    company_id: int
    mes: int
    ano: int


app = FastAPI()


@app.post("/")
def inference(input: Item):

    features = [input.client_id, input.company_id, input.mes, input.ano]
    df = pd.DataFrame([features], columns=["client_id", "company_id", "mes", "ano"])
    df["company_id"] = labelEncoder.fit_transform(df["company_id"])
    prediction = model.predict(df)

    return {"y": prediction}


@app.get("/heart")
def heart():
    t = np.linspace(0, 2 * np.pi, 1000)
    x = 16 * np.sin(t) ** 3
    y = 13 * np.cos(t) - 5 * np.cos(2 * t) - 2 * np.cos(3 * t) - np.cos(4 * t)

    fig, ax = plt.subplots(figsize=(5, 5))
    ax.plot(x, y, color="red", linewidth=2)
    ax.axis("off")
    ax.set_aspect("equal")

    buf = BytesIO()
    plt.savefig(buf, format="png", bbox_inches="tight", pad_inches=0)
    plt.close(fig)
    buf.seek(0)

    return Response(content=buf.read(), media_type="image/png")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
