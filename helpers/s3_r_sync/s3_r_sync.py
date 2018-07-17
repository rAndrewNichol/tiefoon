import boto3, os, shutil

class s3RSync:

    def __init__(self, bucket, key, outfile = "./"):
        self.client = boto3.client("s3")
        self.resource = boto3.resource("s3")
        self.bucket = bucket
        self.key = key if key[-1] == "/" else key + "/"
        self.outfile = outfile
        try:
            os.mkdir(outfile)
        except:
            pass
        self.r_sync(self.key, self.outfile)

    def r_sync(self, key, outfile):
        objects = self.client.list_objects(Bucket = self.bucket, Prefix = key, Delimiter = "/")
        extension = key.strip("/").split("/")[-1]
        try:
            os.mkdir("{}/{}/".format(outfile, extension)) 
        except:
            shutil.rmtree("{}/{}/".format(outfile, extension))
            os.mkdir("{}/{}/".format(outfile, extension))
        if "CommonPrefixes" in objects:
            for pre in objects["CommonPrefixes"]:
                self.r_sync(pre["Prefix"], "{}/{}".format(outfile, extension))
        if "Contents" in objects:
            for content in objects["Contents"]:
                file_name = content["Key"].strip("/").split("/")[-1]
                self.resource.Bucket(self.bucket).download_file(content["Key"], 
                        "{}/{}/{}".format(outfile, extension, file_name))
