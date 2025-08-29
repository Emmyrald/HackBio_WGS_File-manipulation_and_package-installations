#!/usr/bin/env bash
set -euo pipefail

# ====== Config ======
# Provide a name via the first argument, e.g., ./lawal_fuhad.sh "Fuhad"
# Defaults to Fuhad if not provided.
NAME="${1:-Fuhad}"

echo "== Stage 0: Project 1 — Bash Basics =="

# 1) Print your name
echo "Name: $NAME"

# 2) Create a folder titled your name
mkdir -p "$NAME"  # -p avoids error if it already exists

# 3) Create biocomputing directory and change into it
mkdir -p biocomputing
cd biocomputing

# 4) Download these 3 files (2x .gbk to create a duplicate as per instructions)
echo "Downloading wildtype files..."
wget -q https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
wget -q https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
wget -q https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk  # duplicate to create .1

# 5) Move the .fna file to the folder titled your name (which is one level up)
mv -f wildtype.fna "../$NAME/"

# 6) Delete the duplicate gbk file
if [[ -f wildtype.gbk.1 ]]; then
  rm -f wildtype.gbk.1
fi

# 7) Confirm if the .fna file is mutant or wild type (tatatata vs tata)
# Prints matching lines if 'tatatata' exists
echo "Checking for 'tatatata' motif in ${NAME}/wildtype.fna..."
if grep -q 'tatatata' "../$NAME/wildtype.fna"; then
  echo "Mutant motif 'tatatata' FOUND."
else
  echo "Mutant motif 'tatatata' NOT found."
fi

# 8) If mutant, print all matching lines into a new file
if grep -q 'tatatata' "../$NAME/wildtype.fna"; then
  grep 'tatatata' "../$NAME/wildtype.fna" > "../$NAME/mutant.fna"
  echo "Saved matching lines to ../$NAME/mutant.fna"
fi

# 9) Count number of sequence lines (excluding header) in the .gbk file
SEQ_LINES=$(awk '/^ORIGIN/ {found=1; next} found' wildtype.gbk | wc -l)
echo "Sequence lines in wildtype.gbk (after ORIGIN): $SEQ_LINES"

# 10) Print the sequence length of the .gbk file from LOCUS line (3rd field)
SEQ_LEN=$(head -n 1 wildtype.gbk | awk '{print $3}')
echo "Sequence length reported in LOCUS: $SEQ_LEN"

# 11) Print the source organism of the .gbk file (first SOURCE line, excluding the word SOURCE)
SOURCE_ORG=$(grep "^SOURCE" wildtype.gbk | head -n 1 | awk '{$1=""; print $0}' | sed 's/^ *//')
echo "Source organism: $SOURCE_ORG"

# 12) List all the gene names in the .gbk file
echo "Gene names in wildtype.gbk:"
grep '/gene=' wildtype.gbk | sed 's/.*\/gene="//; s/".*//' | sort -u

# 13) Clear terminal space (commented out to keep script output visible)
# clear

# 14) Print command history (may not function as expected in non-interactive shells)
# history


echo
echo "== Project 2: Installing Bioinformatics Software on the Terminal =="

# 1) Install Miniconda (non-interactive) if conda is not present
if ! command -v conda >/dev/null 2>&1; then
  echo "Conda not found. Installing Miniconda to \$HOME/miniconda3 (non-interactive)..."
  cd ~
  wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3.sh
  bash Miniconda3.sh -b -p "$HOME/miniconda3"
  eval "$("$HOME/miniconda3/bin/conda" shell.bash hook)"
  conda init bash || true
  # Return to workspace if we changed dir
  cd - >/dev/null 2>&1 || true
else
  echo "Conda already installed."
fi

# Ensure conda is available in this session
if ! command -v conda >/dev/null 2>&1; then
  eval "$("$HOME/miniconda3/bin/conda" shell.bash hook)"
fi

# 2) Configure channels and create environment 'funtools'
conda config --add channels defaults || true
conda config --add channels bioconda || true
conda config --add channels conda-forge || true

if ! conda env list | awk '{print $1}' | grep -qx "funtools"; then
  conda create -y -n funtools python=3.10
fi

# 3) Activate the funtools environment
# shellcheck disable=SC1091
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate funtools

# 4) Install Figlet (try conda first, fallback to apt if available)
if ! command -v figlet >/dev/null 2>&1; then
  conda install -y -c conda-forge figlet || {
    if command -v sudo >/dev/null 2>&1 && command -v apt >/dev/null 2>&1; then
      sudo apt update && sudo apt install -y figlet
    fi
  }
fi

# 5) Run figlet with your name
if command -v figlet >/dev/null 2>&1; then
  figlet "$NAME" || true
else
  echo "figlet not available; skipping banner."
fi

# 6–13) Install common bioinformatics tools via bioconda
conda install -y bwa
conda install -y blast
conda install -y samtools
conda install -y bedtools
conda install -y spades
spades.py --version || true
conda install -y bcftools
conda install -y fastp
conda install -y multiqc

echo
echo "All tasks completed successfully."
