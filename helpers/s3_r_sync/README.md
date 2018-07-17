## Recursive Sync for AWS S3

** Purpose **
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A simple class meant only to be executed via initialization. Initializing the class with the appropriate arguments will download the *nested* contents of a specified s3 file.

** Usage **
```{python}
from s3_r_sync import s3RSync

s3RSync(bucket = "data-cleaning-tests", 
				key = "cleaners/location/",
				outfile = "./test_results")
```

####class s3RSync
- `bucket` [required] : The s3 bucket containing the desired file structure.
- `key` [required] : The s3 key which will become the root directory of the download.
- `outfile` [default `"./"`] The file to which you would like to place the contents found at the s3 key (relative path from working directory).

**Dependencies**
- boto3 / botocore

**Notes** 
- No updates are printed to stdout during the course of the download. Large and largely recursive downloads may take some time. Feel free to add reporting as desired.