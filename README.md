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
- Polishing with `isoseq refine`
- Reference-based alignment using `pbmm2`
- Quantification with `lr-kallisto`
- Splicing Analysis with `IsoformSwitchAnalyzeR`
- Differential Isoform and Gene Expression Analyses with `DESeq2`

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
- Segmentation and cDNA primer sequences (FASTA)
- GENCODE Reference genome (FASTA) and annotation (GTF/GFF3)


### Installation
1. Clone the repo  
   ```bash
   git clone https://github.com/rboz1/beffert_ho_lab_pacbio_ad_pilot.git
   cd isoseq_pipeline
   ```
   
2. Set up Conda environment or container profile
   ```bash
    conda env create -f ./envs/nextflow_base.yml
    conda activate nextflow_base
   ```

3. Run the pipeline
   ```bash
     nextflow run main.nf -profile conda,sge \
    --input '/path/to/*.subreads.bam' \
    --genome '/path/to/genome.fa' \
    --annotation '/path/to/annotation.gtf' \
    --primers '/path/to/primers.fasta'
   ```
---

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contact

Rachel Bozadjian - rbozadjian@gmail.com  
Project Link: [https://github.com/your-username/isoseq-nextflow](https://github.com/rboz1/beffert_ho_lab_pacbio_ad_pilot.git)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555  
[linkedin-url]: https://www.linkedin.com/in/rachel-bozadjian-203999109
