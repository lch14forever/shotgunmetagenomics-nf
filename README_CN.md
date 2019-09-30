# 宏基因组有参分析流程

## 简介
此流程基于[Nextflow](https://www.nextflow.io/)实现。由新加坡基因组研究院([GIS](https://www.a-star.edu.sg/gis))计算及系统生物学第5组(CSB5)开发。

 - 使用Nextflow最新语法，流程模块化可重复使用
 - 尽可能提供Dockerfile和Conda YAML文件，运算环境可重复
 - 提供多种环境的配置文件，GIS高性能计算(SGE)，AWS (batch)，AWS Cluster (ignite)


## 依赖

### 主流程
 - [Nextflow](https://www.nextflow.io/)
 - Java Runtime Environment >= 1.8

### 质控和去宿主DNA
 - [Fastp](https://github.com/OpenGene/fastp) (>=0.20.0): 去接头
 - [BWA](https://github.com/lh3/bwa) (>=0.7.17): 去宿主DNA
 - [Samtools](https://github.com/samtools/samtools) (>=1.7): 去宿主DNA

### 有参宏基因组分析
 - [Kraken2](https://ccb.jhu.edu/software/kraken2/) (>=2.0.8-beta): 物种分类分析
 - MetaPhlAn2: 物种分类分析
 - SRST2: 抗生素抗药性分析
 - HUMAnN2: 代谢通路分析

## 使用
```sh
shotgunmetagenomics-nf/main.nf
```

## 应用案例
 - Chng *et al*. Whole metagenome profiling reveals skin microbiome dependent susceptibility to atopic dermatitis flares. *Nature Microbiology* (2016)
 - Chng *et al*. Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment. *BioRxiv* (2019)

## 联系人
李陈浩：lichenhao.sg@gmail.com, lich@gis.a-star.edu.sg
