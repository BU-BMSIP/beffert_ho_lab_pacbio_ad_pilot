<!-- PROJECT SHIELDS -->
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<h3 align="center">Alternative Splicing in Alzheimer's Disease with Long-Read PacBio IsoSeq Analysis</h3>

<p align="center">
  A reproducible and modular pipeline for processing PacBio IsoSeq long-read RNA sequencing data using Nextflow.
  Supports transcript quantification, splicing analysis, and differential expression analyses.
</p>

---

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#key-features">Key Features</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#results">Results</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

---

## About The Project

This pipeline provides a streamlined workflow for analyzing long-read PacBio IsoSeq data, from raw subreads to high-confidence full-length isoform annotation and quantification. 

### Key Features

- Demultiplexing and primer removal using `lima`
- Full-length non-chimeric (FLNC) read classification
- Clustering and polishing with `isoseq3 cluster`
- Reference-based alignment using `pbmm2`
- Quantification with `lr-kallisto`

### Built With

- [Nextflow](https://www.nextflow.io/)
- [IsoSeq tools](https://isoseq.how)
- [lr-kallisto](https://github.com/pachterlab/kallisto)
- [IsoformSwitchAnalyzeR](https://www.bioconductor.org/packages/release/bioc/html/IsoformSwitchAnalyzeR.html)
- [DESeq2](https://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)
- Python, R

---

## Getting Started

### Prerequisites

- Nextflow ≥ 22.10
- Conda
- PacBio raw subreads (BAM format)
- Primer sequences (FASTA)
- GENCODE Reference genome (FASTA) and annotation (GTF/GFF3)


### Installation
1. Clone the repo  
   ```bash
   git clone https://github.com/your-username/isoseq-nextflow.git
   cd isoseq-nextflow
   ```
   
2. Set up Conda environment or container profile
  ```bash
    conda env create -f environment.yml
    conda activate isoseq_env
  ```

3. Run the pipeline
   ```bash
     nextflow run main.nf -profile conda,sge \
    --input '/path/to/*.subreads.bam' \
    --genome '/path/to/genome.fa' \
    --annotation '/path/to/annotation.gtf' \
    --primers '/path/to/primers.fasta' ```
---

## Results

### Isoform clustering and annotation

The pipeline generates high-confidence isoform FASTA and GTF files annotated using SQANTI3 and filtered for structural and quality metrics.

![SQANTI3 summary plot](https://github.com/user-attachments/assets/sqanti_summary.png)

---

### Transcriptome QC

Includes:

- Counts of full-length (FL) and full-length non-chimeric (FLNC) reads  
- Isoform classification into categories such as FSM, ISM, NIC, NNC  
- Splice junction validation and novelty statistics

---

### Genome-aligned BAM files

Aligned and indexed BAM files are generated using `minimap2` for visualization in genome browsers like IGV.

---

### MultiQC Summary

Aggregated HTML reports summarize key metrics from CCS, Lima, IsoSeq3, and alignment steps.

![MultiQC report screenshot](https://github.com/user-attachments/assets/multiqc_example.png)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Next Steps

- Add support for hybrid assembly with short-read RNA-seq data
- Expand isoform quantification integration (e.g., Salmon, StringTie2)
- Extend TSS/TTS characterization and alternative polyadenylation (APA) analysis
- Integrate with downstream tools like tappAS or IsoAnnotLite for functional insights

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contact

Rachel Bozadjian - rbozadjian@gmail.com  
Project Link: [https://github.com/your-username/isoseq-nextflow](https://github.com/your-username/isoseq-nextflow)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555  
[linkedin-url]: https://www.linkedin.com/in/rachel-bozadjian-203999109
