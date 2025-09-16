import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from fastapi import FastAPI
import joblib, os, tempfile
from pydantic import BaseModel
from sklearn.preprocessing import LabelEncoder
import numpy as np
from io import BytesIO
from fastapi.responses import Response

model = joblib.load("modelo_regressao_linear.pkl")
labelEncoder = joblib.load("label_encoder.pkl")

class Item(BaseModel):
    client_id: str
    company_id: int  
    mes: int
    ano: int

app = FastAPI()

@app.post("/")
def inference(input: Item):
    client_id_encoded = labelEncoder.transform([input.client_id])[0]
    df = pd.DataFrame([[client_id_encoded, input.company_id, input.mes, input.ano]], 
                      columns=["client_id_encoded", "company_id", "mes", "ano"])
    
    prediction = model.predict(df)
    return {"y": prediction[0]}

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

@app.post("/predict-with-heart")
def predict_with_heart(input: Item):
    client_id_encoded = labelEncoder.transform([input.client_id])[0]
    df = pd.DataFrame([[client_id_encoded, input.company_id, input.mes, input.ano]], 
                      columns=["client_id_encoded", "company_id", "mes", "ano"])
    
    prediction = model.predict(df)
    fig, ax = plt.subplots(figsize=(8, 8))
    
    def animate(frame):
        ax.clear()
        t = np.linspace(0, 2 * np.pi, 1000)
        x = 16 * np.sin(t) ** 3
        y = 13 * np.cos(t) - 5 * np.cos(2 * t) - 2 * np.cos(3 * t) - np.cos(4 * t)
        scale = 1 + 0.2 * np.sin(frame * 0.5)
        x_scaled = x * scale
        y_scaled = y * scale
        
        ax.plot(x_scaled, y_scaled, color="red", linewidth=3)
        ax.fill(x_scaled, y_scaled, color="pink", alpha=0.3)
        ax.text(0, 0, "SÁVIO", fontsize=20, ha="center", va="center", 
                fontweight="bold", color="darkred")
        ax.text(0, 20, f"Predição: {prediction[0]:.2f}", fontsize=16, 
                ha="center", va="center", fontweight="bold", color="blue")
        ax.set_xlim(-25, 25)
        ax.set_ylim(-20, 25)
        ax.axis("off")
        ax.set_aspect("equal")
        
        return ax
    
    ani = animation.FuncAnimation(fig, animate, frames=20, interval=200, repeat=True)   
    with tempfile.NamedTemporaryFile(suffix=".gif", delete=False) as tmp_file:
        ani.save(tmp_file.name, writer='pillow', fps=5)
        plt.close(fig)
        with open(tmp_file.name, 'rb') as f:
            gif_data = f.read()
        os.unlink(tmp_file.name)
        
        return Response(content=gif_data, media_type="image/gif")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
