import os
import re
import subprocess
import json
import pandas as pd
from polyglot.detect import Detector
from polyglot.detect.base import UnknownLanguage
import pycld2

def iterate_json(format_ending="json",path="collection"):
    for root, dirs, files in os.walk(path, topdown=False):
        for name in files:
            if re.search(".{0}".format(format_ending),name):
                json_path = (os.path.join(root,name))
                yield json.load(open(json_path,"r"))

def get_language(x):
    try:
        return Detector(x).language.code
    except UnknownLanguage:
        return None
    except pycld2.error:
        return None

if __name__=="__main__":
    docs = [j for j in iterate_json()]
    docs_dataframe = pd.DataFrame(docs)
    content = docs_dataframe.content
    language = content.apply(get_language)
    print(language)
