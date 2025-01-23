#!/bin/bash

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install prettytable
pip install prettytable

# Run the documentation script
python3 document_queries.py

# Cleanup
deactivate
rm -rf venv

echo "Documentation created in query_documentation.md" 