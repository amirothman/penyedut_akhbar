from polyglot.detect import Detector

def language(text):
    d = Detector(text)
    return d.language
