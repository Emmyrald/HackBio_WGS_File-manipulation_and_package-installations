# Stage 0
__Project 1: BASh Basic__


### 1. Print your name
name='Fuhad'
echo $name

### 2. Create a folder titled your name

mkdir -p $name
#using -p to eliminate error when file already exists

### 3. Create another new directory titled biocomputing and change to that directory with one line of command
mkdir -p  biocomputing && cd biocomputing/

### Download these 3 files:
https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk

wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk

### 5. Move the .fna file to the folder titled your name
mv wildtype.fna $name

### 6. Delete the duplicate gbk file
rm wildtype.gbk.1

### 7. Confirm if the .fna file is mutant or wild type (tatatata vs tata)
grep 'tatatata' Fuhad/wildtype.fna

### 8. If mutant, print all matching lines into a new file
grep 'tatatata' Fuhad/wildtype.fna > Fuhad/mutant.fna

### 9. Count number of lines (excluding header) in the .gbk file
awk '/^ORIGIN/ {found=1; next} found' wildtype.gbk | wc -l

### 10. Print the sequence length of the .gbk file. (Use the LOCUS tag in the first line)
locus tag in the first line
head -n 1 wildtype.gbk | grep "LOCUS" | awk '{print $3}'

### 11. Print the source organism of the .gbk file. (Use the SOURCE tag in the first line)
grep "^SOURCE" wildtype.gbk | head -n 1 | awk '{$1=""; print $0}' | sed 's/^ *//'

### 12. List all the gene names of the .gbk file. Hint {grep '/gene='}
grep '/gene=' wildtype.gbk | sed 's/.*\/gene="//; s/".*//'

### 13. Clear your terminal space and print all commands used today
clear

### 14. List the files in the two folders
history

# Project 2: Installing Bioinformatics Software on the Terminal

### 1. Activate your base conda environment
wget https://repo.anaconda.com/minconda/Miniconda3-latest-Linux-x86_64.sh
### Run installer
bash Miniconda3-latest-Linux-x86_64.sh
Activate conda
conda init

### 2. Create a conda environment named funtools
conda config --add channels default
conda config --add channels bioconda
conda config --add channels conda-forge
### Create environment 'funtools'
conda create -n funtools python=3.10

### 3. Activate the funtools environment
conda activate funtools

### 4. Install Figlet using conda or apt-get
sudo apt install figlet

### 5. Run figlet <your name>
figlet 'Emmyrald'

### 6. Install bwa through the bioconda channel
conda install bwa

### 7. Install blast through the bioconda channel
conda install blast

### 8. Install samtools through the bioconda channel
conda install samtools

### 9. Install bedtools through the bioconda channel
conda install bedtools

### 10. Install spades.py through the bioconda channel
conda install spade
spades.py --version

### 11. Install bcftools through the bioconda channel
conda install bcftools

### 12. Install fastp through the bioconda channel
conda install fastp

### 13. Install multiqc through the bioconda channel
conda install multiqc
