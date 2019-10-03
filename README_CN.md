# 宏基因组有参分析流程

## 简介
此流程基于[Nextflow](https://www.nextflow.io/)实现。由新加坡基因组研究院([GIS](https://www.a-star.edu.sg/gis))计算及系统生物学第5组(CSB5)开发。

 - 使用Nextflow最新语法，流程模块化可重复使用
 - 尽可能提供Dockerfile和Conda YAML文件，运算环境可重复
 - 提供多种环境的配置文件，GIS高性能计算(SGE)，AWS (batch)，AWS Cluster (ignite)

## 开发进程
 - [x] 加入去宿主DNA模块
   - [x] Docker支持
   - [x] Conda支持
 - [x] 加入kraken2和bracken
   - [x] Docker支持
   - [x] Conda支持
 - [ ] 加入HUMAnN2 (间接支持MetaPhlAn2)
 - [ ] 加入SRST2
 - [x] nf-core style风格配置文件 (params and profiles)
   - [x] 标注执行(standard)
   - [x] 测试(test)
   - [x] GIS集群(gis)
   - [ ] AWS batch
   - [ ] AWS HPC
  - [ ] nf-core风格文档

## 依赖

### 主流程
 - [Nextflow](https://www.nextflow.io/)
 - Java Runtime Environment >= 1.8

### 质控和去宿主DNA
 - [Fastp](https://github.com/OpenGene/fastp) (>=0.20.0): 去接头
 - [BWA](https://github.com/lh3/bwa) (>=0.7.17): 去宿主DNA
 - [Samtools](https://github.com/samtools/samtools) (>=1.7): 去宿主DNA

### 有参宏基因组分析
 - [Kraken2](https://ccb.jhu.edu/software/kraken2/) (>=2.0.8-beta) + [Bracken](https://ccb.jhu.edu/software/bracken/) (>=2.5): 物种分类分析
 - MetaPhlAn2: 物种分类分析
 - SRST2: 抗生素抗药性分析
 - HUMAnN2: 代谢通路分析

## 使用

在流程附带的数据上测试

```sh
$ shotgunmetagenomics-nf/main.nf
N E X T F L O W  ~  version 19.09.0-edge
Launching `./main.nf` [cheesy_volhard] - revision: dc7259a08e
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (8)
[d4/2492b7] process > DECONT (SRR1950772)  [100%] 2 of 2 ✔
[3f/d7402d] process > KRAKEN2 (SRR1950772) [100%] 2 of 2 ✔
[de/a05395] process > BRACKEN (SRR1950772) [100%] 4 of 4 ✔
Completed at: 02-Oct-2019 16:21:34
Duration    : 3m 47s
CPU hours   : 0.5
Succeeded   : 8
```

显示全部帮助信息

```
$ shotgunmetagenomics-nf/main.nf --help
```

在GIS集群上使用

```sh
$ shotgunmetagenomics-nf/main -profile gis --read_path PATH_TO_READS
```

使用Docker容器

```
$ shotgunmetagenomics-nf/main -profile docker --read_path PATH_TO_READS
```

支持提供多个profile, 例如: `-profile docker,test`.


## 应用案例
 - Chng *et al*. Whole metagenome profiling reveals skin microbiome dependent susceptibility to atopic dermatitis flares. *Nature Microbiology* (2016)
 - Chng *et al*. Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment. *BioRxiv* (2019)
 - Nandi *et al*. Gut microbiome recovery after antibiotic usage is mediated by specific bacterial species. *BioRxib* (2018)


## 联系人
李陈浩：lichenhao.sg@gmail.com, lich@gis.a-star.edu.sg
