import os
import os.path
from ftplib import FTP, error_perm

# Config
FTP_HOST = "202.62.221.6"
FTP_PORT = 0
FTP_USERNAME = "andrewc"
FTP_PW = "rogerwong"

FTP_FILE_DIR = "/var/www/html/mobile/ios/chartLib"
LOCAL_FILENAME = "ChartFramework.framework"

# Func
def uploadFileOrDir(ftp, path):
    for name in os.listdir(path):
        localpath = os.path.join(path, name)
        if os.path.isfile(localpath):
            print("STOR", name, localpath)
            ftp.storbinary('STOR ' + name, open(localpath, 'rb'))
        elif os.path.isdir(localpath):
            print("MKD", name)

            try:
                ftp.mkd(name)

            # ignore "directory already exists"
            except error_perm as e:
                print("MKD error: %s" % e)
                if not e.args[0].startswith('550'):
                    raise

            print("CWD", name)
            ftp.cwd(name)
            uploadFileOrDir(ftp, localpath)
            print("CWD", "..")
            ftp.cwd("..")
        print("PWD %s" % ftp.pwd())


def makeDir(dir):
    try:
        ftp.mkd(dir)

    # ignore "directory already exists"
    except error_perm as e:
        print("MKD error: %s" % e)
        if not e.args[0].startswith('550'):
            raise


# Script
try:
    # connect ftp
    ftp = FTP()
    ftp.connect(FTP_HOST, FTP_PORT)
    ftp.login(FTP_USERNAME, FTP_PW)

    # change ftp dir
    ftp.cwd(FTP_FILE_DIR)
    makeDir(LOCAL_FILENAME)
    ftp.cwd(LOCAL_FILENAME)

    # change local dir
    targetDir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(targetDir)
    os.chdir("..")

    # upload target file or dir
    if os.path.exists(LOCAL_FILENAME):
        uploadFileOrDir(ftp, LOCAL_FILENAME)
    else:
        print(f"{os.path.join(os.getcwd(), LOCAL_FILENAME)} doesn't exist.")

    ftp.quit()
except Exception as err:
    print("UPLOAD FAILt#error message: %s" % err)
