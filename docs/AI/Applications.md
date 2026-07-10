## Environment Setup
### Miniconda
`Miniconda` is a minimal installer for the `Anaconda` distribution of the `Python` programming language. It provides the `conda` package manager and a core Python environment without automatically installing the full suite of data science libraries available in `Anaconda`. Users can selectively install additional packages, creating a customized environment that aligns with their specific needs.
```sh
# Installing
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -u
eval "$(/home/$USER/miniconda3/bin/conda shell.$(ps -p $$ -o comm=) hook)"

# Init
conda init
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels nvidia # only needed if you are on a PC that has a nvidia gpu
conda config --add channels pytorch
conda config --set channel_priority strict

# Deactivating Base
conda config --set auto_activate_base false

# Managing Virtual Environments
conda create -n ai python=3.11
# Activating the Environment
conda activate ai
# Deactivating the Environment
conda deactivate

# Essential Setup
conda install -y numpy scipy pandas scikit-learn matplotlib seaborn transformers datasets tokenizers accelerate evaluate optimum huggingface_hub nltk category_encoders
conda install -y pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
pip install requests requests_toolbelt

# Updates
conda update --all
```
## JupyterLab
`JupyterLab` is an interactive development environment that provides web-based coding, data, and visualization interfaces. Due to its flexibility and interactive features, it's a popular choice for data scientists and machine learning practitioners.
```bash
conda install -y jupyter jupyterlab notebook ipykernel
jupyter lab
# Type your Python code into the code cell and press Shift + Enter to execute it. For example:
print("Hello, JupyterLab!")
```
### Restarting the Kernel
Restarting the `kernel` clears all variables, functions, and imported modules from memory, allowing you to start fresh without shutting down `JupyterLab` entirely.

To restart the `kernel`:

1. Open the `Kernel` menu in the top toolbar.
2. Select `Restart Kernel` to reset the environment while preserving cell outputs, or `Restart Kernel and Clear All Outputs` to also remove all previously generated outputs from the notebook.
## Python Libraries for AI
Python is a versatile programming language widely used in Artificial Intelligence (AI) due to its rich library ecosystem that provides efficient and user-friendly tools for developing AI applications. This section focuses on two prominent Python libraries for AI development: `Scikit-learn` and `PyTorch`.
### Scikit-learn
`Scikit-learn` is a comprehensive library built on `NumPy`, `SciPy`, and `Matplotlib`. It offers a wide range of algorithms and tools for machine learning tasks and provides a consistent and intuitive API, making implementing various machine learning models easy.
### PyTorch
`PyTorch` is an open-source machine learning library developed by Facebook's AI Research lab. It provides a flexible and powerful framework for building and deploying various types of machine learning models, including deep learning models.
## Datasets
In AI, the quality and characteristics of the data used to train models significantly impact their performance and accuracy. `Datasets`, which are collections of data points used for analysis and model training, come in various forms and formats, each with its own properties and considerations. `Data preprocessing` is a crucial step in the machine-learning pipeline that involves transforming raw data into a suitable format for algorithms to process effectively.

Several key attributes characterize a good dataset: `Relevance`, `Completeness`, `Consistency`, `Quality`, `Representativeness`, `Balance`, `Size`.
```python
import pandas as pd

# Load the dataset
data = pd.read_csv("./demo_dataset.csv")

# Display the first few rows of the dataset
print(data.head())

# Get a summary of column data types and non-null counts
print(data.info())

# Identify columns with missing values
print(data.isnull().sum())
```
## Data Preprocessing
`Data preprocessing` transforms raw data into a suitable format for machine learning algorithms. Key techniques include:

- `Data Cleaning`: Handling missing values, removing duplicates, and smoothing noisy data.
- `Data Transformation`: Normalizing, encoding, scaling, and reducing data.
- `Data Integration`: Merging and aggregating data from multiple sources.
- `Data Formatting`: Converting data types and reshaping data structures.

Effective preprocessing addresses inconsistencies, missing values, outliers, noise, and feature scaling, improving the accuracy, efficiency, and robustness of machine learning models.
### Identify Invalid Values
Check if every field has a valid value (numeric, within a certain range, string, etc.)
### Handling Invalid Entries
We can choose between several options:
- Discard them (preferred when data accuracy is paramount).
- Input them (replacing missing or invalid values in a dataset with estimated values, good if missing values can lead to biased or inaccurate results). For basic numeric columns use the average. For categoric columns, the most frequent value.
## Data Transformation
`Data transformations` improve the representation and distribution of features, making them more suitable for machine learning models. These transformations ensure that models can efficiently capture underlying patterns by converting categorical variables into machine-readable formats and addressing skewed numerical distributions. They also enhance trained models' stability, interpretability, and predictive performance.

`Encoding` converts categorical values into numeric form so machine learning algorithms can utilize these features.
### Handling Skewed Data
`Scaling` or transforming these skewed features helps models better capture patterns in the data. One common transformation is applying a `log` transform to compress large values more than small ones, resulting in a more balanced distribution and less dominated by outliers. By doing this, models often gain improved stability, accuracy, and generalization ability.
### Data Splitting
`Data splitting` involves dividing a dataset into three distinct subsets—`training`, `validation`, and `testing`—to ensure reliable model evaluation. By having separate sets, you can train your model on one subset, fine-tune it on another, and finally test its performance on data it has never seen before.
## Metrics for Evaluating a Model
`Accuracy` is the proportion of correct predictions out of all predictions made. It measures how often the model classifies instances correctly. Computed as `(true positives + true negatives) / (all instances)`.

`Precision` measures how often the model’s predicted positives are truly positive. Computed as `true positives / (true positives + false positives)`.

`Recall` measures the model’s ability to identify all positive instances. Computed as `true positives / (true positives + false negatives)`.

`F1-score` is the harmonic mean of `precision` and `recall`. Computed as `2 * (precision * recall) / (precision + recall)`.
## Spam Classification
1. The first step in our process is to download this dataset.
2. Extract the dataset.
3. List the extracted files.
4. Load the dataset.
5. Display basic info about the dataset.
6. Check for missing values.
7. Check for duplicates and remove them.
```python
import requests
import zipfile
import io

# URL of the dataset
url = "https://archive.ics.uci.edu/static/public/228/sms+spam+collection.zip"
# Download the dataset
response = requests.get(url)
if response.status_code == 200:
    print("Download successful")
else:
    print("Failed to download the dataset")

# Extract the dataset
with zipfile.ZipFile(io.BytesIO(response.content)) as z:
    z.extractall("sms_spam_collection")
    print("Extraction successful")

import os

# List the extracted files
extracted_files = os.listdir("sms_spam_collection")
print("Extracted files:", extracted_files)	

import pandas as pd

# Load the dataset
df = pd.read_csv(
    "sms_spam_collection/SMSSpamCollection",
    sep="\t",
    header=None,
    names=["label", "message"],
)

# Display basic information about the dataset
print("-------------------- HEAD --------------------")
print(df.head())
print("-------------------- DESCRIBE --------------------")
print(df.describe())
print("-------------------- INFO --------------------")
print(df.info())

# Check for missing values
print("Missing values:\n", df.isnull().sum())

# Check for duplicates
print("Duplicate entries:", df.duplicated().sum())

# Remove duplicates if any
df = df.drop_duplicates()
```
### Preprocessing the Spam Dataset
1. Download the required NLTK data files. These include `punkt` for tokenization and `stopwords` for removing common words that do not contribute to meaning.
2. `Lowercasing the text` ensures that the classifier treats words equally, regardless of their original casing.
3. `Removing unnecessary punctuation and numbers` simplifies the dataset by focusing on meaningful words.
4. `Tokenization` divides the message text into individual words or tokens, a crucial step before further analysis.
5. `Stop words` are common words like `and`, `the`, or `is` that often do not add meaningful context.
6. `Stemming` normalizes words by reducing them to their base form (e.g., `running` becomes `run`).
7. `Joining Tokens Back into a Single String`. While tokens are useful for manipulation, many machine-learning algorithms and vectorization techniques (e.g., TF-IDF) work best with raw text strings.
```python

```
### Feature Extraction
`Feature extraction` transforms preprocessed SMS messages into numerical vectors suitable for machine learning algorithms. Since models `cannot directly process raw text data`, they rely on numeric representations—such as counts or frequencies of words—to identify patterns that differentiate spam from ham.
### Training and Evaluation
After preprocessing the text data and extracting meaningful features, we train a machine-learning model for spam detection. We use the `Multinomial Naive Bayes` classifier, which is well-suited for text classification tasks due to its probabilistic nature and ability to efficiently handle large, sparse feature sets.

After training and fine-tuning the spam detection model, assessing its performance on new, unseen SMS messages is critical. This evaluation helps verify how well the model generalizes to real-world data and highlights improvement areas. The evaluation mirrors the preprocessing and feature extraction steps applied during training, ensuring a consistent and fair assessment of the model’s true predictive capabilities.

#### Using joblib for Saving Models
After confirming satisfactory performance, preserving the trained model to be reused later is often necessary. By saving the model to a file, users can avoid the computational expense of retraining it from scratch each time. This is especially helpful in production environments where quick predictions are required.
```python
import joblib

# Save the trained model to a file for future use
model_filename = 'spam_detection_model.joblib'
joblib.dump(best_model, model_filename)

print(f"Model saved to {model_filename}")

############
# Load the saved model
loaded_model = joblib.load(model_filename)

# Preprocess new messages before prediction
new_data_processed = [preprocess_message(msg) for msg in new_messages]

# Make predictions on the preprocessed data
predictions = loaded_model.predict(new_data_processed)
```
## Network Anomaly Detection
`Anomaly detection` identifies data points that deviate significantly from the norm. In cybersecurity, such anomalies can indicate malicious activities, network intrusions, or other security breaches. `Random forests`, which are ensembles of `decision trees`, effectively handle complex, high-dimensional data and can be used to detect these anomalous patterns.

1. Download NSL-KDD dataset.
2. Load the dataset by first importing all necessary libraries.
3. Defining Column Names and File Path.
4. Reading the Dataset into a DataFrame