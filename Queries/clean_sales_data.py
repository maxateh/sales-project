import pandas as pd

# Load Excel file (you can use read_csv if it's a CSV)
df = pd.read_csv("5mSalesRecords.csv")  # Change to your file path if needed

# Convert date columns to YYYY-MM-DD format
df["Order Date"] = pd.to_datetime(df["Order Date"], errors="coerce").dt.strftime('%Y-%m-%d')
df["Ship Date"] = pd.to_datetime(df["Ship Date"], errors="coerce").dt.strftime('%Y-%m-%d')

# Optional: Remove rows with invalid or missing dates
df = df.dropna(subset=["Order Date", "Ship Date"])

# Export as a clean CSV
df.to_csv("cleaned_sales_data.csv", index=False)

print("✅ Cleaned file saved as 'cleaned_sales_data.csv'")