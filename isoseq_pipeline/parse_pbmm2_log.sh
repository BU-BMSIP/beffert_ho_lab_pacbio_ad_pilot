#!/bin/bash
# Generate header
echo "Sample,Mapped_Reads,Mapping_Rate,Avg_Coverage" > pbmm2_stats.csv

# Parse each pbmm2 log
for log in pbmm2*.log; do
  sample=$(basename "$log" .log | sed 's/pbmm2_//')
  
  # Extract metrics (adjust grep patterns if needed)
  mapped_reads=$(grep -oP "aligned reads:\s*\K[\d,]+" "$log" | tr -d ',')
  mapping_rate=$(grep -oP "mapping rate:\s*\K[\d.]+" "$log")
  coverage=$(grep -oP "average coverage:\s*\K[\d.]+" "$log")
  
  # Append to CSV
  echo "$sample,$mapped_reads,$mapping_rate,$coverage" >> pbmm2_stats.csv
done