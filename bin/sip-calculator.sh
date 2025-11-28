#! /usr/bin/env bash

starting_capital=$(gum input --placeholder "Enter Starting Capital (e.g. 10000,0)")
echo "Starting Capital: $starting_capital"

monthly_investment=$(gum input --placeholder "Enter monthly investment (e.g. 500)")
echo "Monthly Investment: $monthly_investment"

rate=$(gum input --placeholder "Enter annual interest rate in % (e.g. 8)")
echo "Annual Interest Rate: $rate%"

years=$(gum input --placeholder "Enter number of years (e.g. 5)")
echo "Years: $years"

compounding=$(gum choose monthly quarterly annually)
echo "Compounding: $compounding"

python - <<EOF
# import matplotlib.pyplot as plt
import plotext as plt

# Parameters
monthly_investment = 500
rate = 0.08
years = 5
compounding = "monthly"

# Determine compounding frequency
if compounding == "monthly":
    n = 12
elif compounding == "quarterly":
    n = 4
elif compounding == "annually":
    n = 1

r = rate / n
months = years * 12

# Track capital growth over time
capital = []
total_invested = 0

for m in range(1, months + 1):
    t = (months - m + 1) / 12
    total_invested += monthly_investment
    value = sum(
        monthly_investment * (1 + r) ** (n * ((months - i + 1)/12))
        for i in range(1, m + 1)
    )
    capital.append(value)

# Plot
plt.figure(figsize=(10, 6))
plt.plot(range(1, months + 1), capital, label="Total Capital")
plt.plot(range(1, months + 1), [(i * monthly_investment) for i in range(1, months + 1)],
         linestyle="--", label="Total Invested", color="orange")
plt.xlabel("Month")
plt.ylabel("Amount")
plt.title(f"SIP Capital Growth over {years} Years")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
EOF
