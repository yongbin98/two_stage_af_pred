# A Two-Stage Deep Learning Framework for Atrial Fibrillation Prediction Using RR Interval-Based Embeddings

This repository contains the implementation of the paper:
“A Two-Stage Deep Learning Framework for Atrial Fibrillation Prediction Using RR Interval-Based Embeddings.”

# Overview

We propose a lightweight two-stage deep learning model for early atrial fibrillation (AF) prediction using RR interval (RRI) embeddings.

Stage 1: Learns discriminative features from short-term RRIs.

Stage 2: Integrates features over longer horizons (up to 1 hour before AF onset).

Designed for computational efficiency, making it suitable for real-time and wearable applications.

# Datasets
Due to size constraints, datasets are not included in this repository.
All data used in this work is publicly available online (e.g., MIT-BIH AFDB, CinC Challenge datasets, etc.).
Input: RR Interval time series
Label: Binary (pre-AF, NSR)
