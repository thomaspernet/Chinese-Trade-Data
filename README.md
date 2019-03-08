# Normalisation Chinese Trade Data 2000-2010

This program proposes to normalize the Chinese Trade Data in a very simple way. The workflow for this project is straightforward, the data is ingested from Google Cloud Storage, and then we normalize the data with Python and Stata. In the last stage of the pipeline stores the output data both in Google Cloud Storage and Big Query.

The final dataset is composed of eleven tables, for each year between 2000 and 2010. The variables are the following:

- `Date`
- `ID`
- `Company_name`
- `Business_type`
- `Trade_type`
- `province`
- `city_prod`
- `imp_exp`
- `matching_city`
- `HS`
- `Origin_and_destination`
- `value`
- `Quantity`

The files are accessibles here:

- [Google Drive](https://drive.google.com/open?id=19s7TfUL3g34NeEhixXYzcgUbzGWsiK18)
- Big Query (upon request)
- [Baidu Yun](https://pan.baidu.com/s/1DDCLq7OchEVP9NZOKvQC0g)
  - password: *2nbx*

## Summary Statistics

<iframe src="https://e.infogram.com/ae0d032f-2dd9-412a-afdd-a6951842f1a5?src=embed" title="Chinese_trade" width="700" height="1944" scrolling="no" frameborder="0" style="border:none;" allowfullscreen="allowfullscreen"></iframe><div style="padding:8px 0;font-family:Arial!important;font-size:13px!important;line-height:15px!important;text-align:center;border-top:1px solid #dadada;margin:0 30px"><a href="https://infogram.com/ae0d032f-2dd9-412a-afdd-a6951842f1a5" style="color:#989898!important;text-decoration:none!important;" target="_blank">Chinese_trade</a><br><a href="https://infogram.com" style="color:#989898!important;text-decoration:none!important;" target="_blank" rel="nofollow">Infogram</a></div>

## Why Normalized the data

A rigorous work has been applied through the pipeline to normalize the data. The idea is to access the data at any time, fast and with little data preparation.

Most of the time, the data comes in unstructured, with different settings from year to year and requires a heavy regularization process. The computation costs are large both in term of time and resources. With such unstructured data, the quality of the final dataset is extremely correlated with the amount of error accumulated during the preparation process.

This program proposes to overcome all those issues with a regularized data workflow to access the standardized Chinese Trade Data from 2000 to 2010 directly from the cloud.

## Issue with Stata

The source data has been provided with `.dta` format. This format incurred a very high resources consumption burden. In fact, a Stata format file is, on average, ten times larger than standard CSV files. It is important to mention that Stata is not a program that optimizes the computation in memory.

Stata gobbles up most of the memory of the computer during the process. It is not uncommon that an average computer will crash with a Stata program when working with large datasets. The Chinese Trade data does not make an exception.

The raw data has two shortcomings which are inherent to Stata:

- The `.dta` are large, very large! To give an example, the trade data 2006 has a size of 20GB..
- The `.dta` are not saved in Unicode, therefore it requires to use Stata to translate each dataset before to proceed to another programming language.

Any programming software like R or Python has libraries to import Stata files easily. It would have been very convenient to make the overall process with Python without the need of Stata. However, the second shortcoming imposes to open the datasets at least once with Stata to translate the `.dta` files.

If Stata was made in a way to optimize the memory allocation, this translation step would not be a problem. Since each file is huge, it is literally impossible to translate the files immediately.

One way to perform this step is to create a chunk of files with the source data. Let's say, the original data has a size of 4GB, the program needs to split the data in chunks of less than 800MB.

Another issue arises with this workflow. It is impossible to translate the `n` chunks of files in a loop with Stata. In fact, Stata crashes when to total amount of files translated exceed 450MB.

One can manually open Stata for every `n` files, translated them and make sure the size is lower than 450MB, although this is a time-consuming process and prompt to error.

In the Normalization Workflow section, we will detail the workaround we used to automatize the translation step.

## Unstructured data

The raw data is made of eleven zip files. There are three main differences between all of the data:

1. Variables name

The years before 2006 included are written in plain English. After 2006, there are labeled in Chinese.

1. Import/export variable encoding

The import/export variable is encoded differently from 2000 to 2006 and 2007 to 2010. The former group is encoded as follow: 进口 for import and 出口 for export while the latter group is 1 for import and 0 for export.

1. One file vs chunk files

The raw data before 2006 included are stored in one single file. It helps to explain why some files are up to 20GB. The zip files after 2007 are already stored in chunks, but not small enough to proceed to immediate translation.

## Normalisation Workflow

For the standardization process, we naturally choose 2007 as a threshold to take into account the difference between the raw data. Say differently, we apply different filters before 2007 and after to achieve our goal of normalization.

The diagram below shows the pipeline

<img src="https://github.com/thomaspernet/Chinese_Trade_Data/raw/master/img/1.png">

The overall process is in the file named `01_all_process.sh`  and a jupyter notebook. The `sh` file deals with the Stata part while Python takes care of the remaining stages.

The jupyter notebook pilots the overall translating and normalization process while calling the shell when required. All the program works in a loop and explicitly proceeds as follow:

1. **Upload the data from GCS**

- The first step of the process consists of downloading the raw data from Google Cloud Storage. Once the file is downloaded, the process `01_all_process.sh`  is triggered.

  1. Rename the do file and sh file with the correct year
  2. `01_all_process.sh`  process

  This process is divided into two parts:

  - Year before *2006*

  - - For the raw data before 2006, the program starts by creating small chunk of files from the source file.

    - Then, it renames the variables in the dataset. All variables have the same name throughout the years.

    - The crucial step done with Stata remains to translate all those small pieces of files.

    - - The tricks we employed to avoid Stata to be killed is to run Stata with the command line. We actually move one by one all the `.dta` files in a subfolder so that Stata can translate without crashing. In fact, we loop the same do file over every intermediates `.dta` files.

    - Last but not least, we save the dataset in CSV

  - Year after 2006

  - - For the raw data after 2006, the program starts by creating small chunk of files from the source file.
    - Then, it uses the same tricks to translate all the files
    - Finally, it renames each variable name with the proper name and saves it as CSV

4. Prepare the dataset with Python

- Download Extra data from [Google Drive](https://drive.google.com/open?id=1wTyYGYPEmmxA-owdrPOJlBSnwuj2MQcp)
- In the jupyter notebook, we load the data from Google Drive, not locally. 
- Extract city name from a list 
- - The cities come from [here](http://data.acmr.com.cn/member/city/city_md.asp)
  - They have been proceeded with R, from this [script](https://drive.google.com/open?id=1zSG7TZS_-3lB8Xd6MEMADeQHp6sZCyK6)
  - If we can’t find the cites in the list, then we use:
    - the *adress*
    - If some firms have missing values, we will use the *company name*.
    - If we can’t find the cities in the company name, then we use this list 
    - ['省', '内蒙古自治区', '西藏自治区', '新疆维吾尔', '广西壮族']
    - Else, we set it to 其他

- Deal with the business name

  - Extract business type from *company name* if the company name is null
  - If can’t find business type then we set it to 其他
- Deal with intermediate firms

  - If company name includes the following 进出口, 贸易, 外贸,外经, 经贸, 工贸, 科贸, then there are intermediates firms
- We aggregated the data with the following variables 

  - `Date`
  - `ID`
  - `Business_type`
  - `Trade_type`
  - `province`
  - `City`
  - `Imp_exp`
  - `HS`
  - `Origin_and_destination`
- If any of those variables has a `NaN`, it won’t be aggregated!

5. Move to Google cloud storage 

6. Move to Big Query

That's it, the program takes several hours to translate all the files.


