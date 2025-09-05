# CovInsight — COVID-19 Analytics Dashboard

A single-figure, themed **Python/Matplotlib** dashboard that reads **CovidDeaths** and **CovidVaccinations** from **SQL Server**, computes per-capita and severity metrics, and saves a high-resolution JPG.  
This project intentionally ships **without an interactive slicer**; the time scope is fixed in the SQL (you can change it).

---

## Features

- **One-page dashboard** (no overlap) saved to a JPG.
- **Themeable** via a JSON palette (orange / pink / green, plus good/neutral/bad accents).
- **KPI cards**: Global cases, deaths, and CFR%.
- **Charts**:
  1) Top locations by **Infection %**  
  2) Top locations by **Death %**  
  3) **Continents** by death % of population  
  4) **Stacked bar**: total cases vs total deaths (top by cases)  
  5) **Gauge**: Global CFR%  
  6) **Scatter**: Median age vs deaths per million  
  7) **Line + area**: Global new cases & new deaths over time
- **Font warnings suppressed**; uses safe defaults (DejaVu Sans/Arial/Segoe UI).
- Robust layout using `constrained_layout=True` + tuned tick padding.

---

## Quick start

1) **Prereqs**
   - Windows with **SQL Server 2022** (or compatible).
   - MS **ODBC Driver 17/18 for SQL Server** installed.
   - Python 3.9+ with:
     ```bash
     pip install pandas matplotlib pyodbc pillow
     ```

2) **Data expected in SQL Server**
   - Database: `COVID_19`
   - Tables: `dbo.CovidDeaths`, `dbo.CovidVaccinations`
   - Minimal columns used:

     **CovidDeaths**  
     `iso_code, continent, location, date, population, new_cases, new_deaths, total_cases, total_deaths, total_cases_per_million, total_deaths_per_million`

     **CovidVaccinations**  
     `iso_code, date, median_age, population_density, stringency_index`

3) **Configure paths** in the script
   - Theme JSON: `THEME_JSON_PATH`, e.g.  
     `C:\Data\Theme_orange_pink_green.json`
   - Output JPG: `OUT_PATH`, e.g.  
     `C:\Users\linke\OneDrive - AL-Hussien bin Abdullah Technical University\Desktop\Current research\Data Analytics portfolio\Covid\Covid_19_dashboard.jpg`
   - Connection (Windows auth example):
     ```python
     conn = pyodbc.connect(
         "DRIVER={ODBC Driver 17 for SQL Server};"
         "SERVER=SALEEM;"
         "DATABASE=COVID_19;"
         "Trusted_Connection=Yes;"
     )
     ```

4) **Run** the script. It will render the dashboard and save the JPG to `OUT_PATH`.

---

## How the metrics are computed

- **Infection %** = `total_cases / population * 100`  
- **Death %**     = `total_deaths / population * 100`  
- **CFR %**       = `total_deaths / total_cases * 100`  
- **Per-million** rates use OWID’s precomputed columns when available.  
- “Latest snapshot” is the **most recent date available per location** in your fixed time scope (OWID aggregates like `OWID_*` are excluded in rankings).

---

## Time scope (no slicer)

The script queries **all dates** by default. To limit to specific years or dates:
- Add a filter inside the SQL, e.g.
  ```sql
  WHERE iso_code NOT LIKE 'OWID_%'
    AND YEAR([date]) IN (2020, 2021, 2022)
  ```
- Or filter a date range:
  ```sql
  AND [date] BETWEEN '2020-01-01' AND '2022-12-31'
  ```

Re-run the script after changes.

---

## File layout (suggested)

```
/project
  |-- covid_dashboard.py           # main script
  |-- Theme_orange_pink_green.json # theme file
  |-- README.md                    # this file
  |-- output/
       └── Covid_19_dashboard.jpg
```

---

## Troubleshooting

- **IM002 / “Data source name not found”**  
  Install ODBC Driver 17/18; confirm the driver name matches exactly in the connection string. If not on Windows auth, use `UID=...;PWD=...;`.

- **Font warnings (“findfont”)**  
  Already suppressed. We also use safe families (`DejaVu Sans`, `Arial`, `Segoe UI`).

- **Charts overlapping**  
  The script uses `constrained_layout=True` and tuned `height_ratios`. If you still see crowding, reduce `TOP_N` from 10 to 8 and keep x-tick rotation at ~55°.

- **JPG not produced**  
  Ensure `Pillow` is installed and the directory exists. The script creates directories automatically with `os.makedirs(..., exist_ok=True)`.

---

## Interpreting the dashboard (short)

- **Per-capita views** (infection %, death %) compare risk across countries.  
- **Stacked counts** show concentration of global burden (large populations).  
- **CFR% gauge** is sensitive to testing: lower ascertainment inflates CFR.  
- **Age vs deaths/million** typically shows a **positive correlation** (older societies → higher mortality), with spread due to policy timing, vaccination, variant mix, and capacity.

---

## Extending

- Add vaccination coverage to the snapshot (fully/boosters) and stratify CFR by vax status (if available).  
- Add a **year or date parameter** at the top of the script to rebuild the dashboard for different periods.  
- Export as **PDF/PNG** or embed in a report generator.  
- Fit a multivariable model (age, stringency, density) to explain mortality variance.

---

## Acknowledgements & License

- Data: **Our World in Data (OWID)** — please comply with their license and citation guidelines.  
- This project is for analytical/research use; clinical decisions should not rely solely on these visuals.

---

## Citation (example)

> CovInsight: COVID-19 Analytics Dashboard (Python/Matplotlib, SQL Server).  
> Data: Our World in Data — COVID-19 dataset.  
> Author: Dr. Saleem (Industrial Engineering & Data Analytics).
