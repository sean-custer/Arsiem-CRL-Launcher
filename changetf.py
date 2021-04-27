# This file takes input from a flask app, and modifies the Terraform main.tf files in both the NMapLab and PacketLab resource groups,
#  and deletes the terraform.tfstate files located in those folders in order to spool up new instances of resource groups
import os
import time
import subprocess
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
@app.route('/api/submit', methods=['POST'])
def get_data_from_react():
    data = request.get_json()
    clone_instances(data["data"])
    return data

if __name__ == '__main__':
    app.run()

def clone_instances(data_from_site):
    numStudents = data_from_site
    resourceGroupNum = 1
    cwd = os.getcwd()

    for x in range(numStudents):

        #############################################################################
        #                    CHANGE THIS PATH TO YOUR PACKETLAB 'main.tf' DIRECTORY #
        #############################################################################
        
        with open(cwd + r'\PacketLab\main.tf', 'r+') as f: #r+ does the work of rw
            lines = f.readlines()
            
            for i, line in enumerate(lines):

                if line.strip().startswith('name'):
            
                    x = line.split('"')
                    if int(resourceGroupNum) == 1:
                        x[1] += str(resourceGroupNum)
                    else:
                        newx = x[1].replace(str(int(resourceGroupNum - 1)), str(resourceGroupNum))
                        x[1] = newx
                    resourceGroupNum = int(resourceGroupNum) + 1
                    
                    newline = '"'.join(x)
                
                    lines[i] = newline

            f.seek(0)
            for line in lines:
                f.write(line)
        f.close()
        #############################################################################
        #                    CHANGE THIS PATH TO YOUR PACKETLAB DIRECTORY           #
        #############################################################################

        os.chdir(cwd + r'\PacketLab')
        os.system("terraform init")
        os.system("terraform apply -auto-approve")
        os.system("del /f terraform.tfstate")
        os.system("del /f terraform.tfstate.backup")
        resourceGroupNum = 1

        #############################################################################
        #                CHANGE THIS PATH TO YOUR MOODLEDEV 'main.tf' DIRECTORY     #
        #############################################################################

        with open(cwd + r'\NMapLab\main.tf', 'r+') as f: #r+ does the work of rw
            lines = f.readlines()
            
            for i, line in enumerate(lines):

                if line.strip().startswith('name'):
            
                    x = line.split('"')
                    if int(resourceGroupNum) == 1:
                        x[1] += str(resourceGroupNum)
                    else:
                        newx = x[1].replace(str(int(resourceGroupNum - 1)), str(resourceGroupNum))
                        x[1] = newx
                    resourceGroupNum = int(resourceGroupNum) + 1
                    
                    newline = '"'.join(x)
                
                    lines[i] = newline

            f.seek(0)
            for line in lines:
                f.write(line)
        f.close()
        #############################################################################
        #                    CHANGE THIS PATH TO YOUR NMAPLAB DIRECTORY             #
        #############################################################################
        os.chdir(cwd + r'\NMapLab')
        #os.system("terraform init")
        #os.system("terraform apply -auto-approve")
        #os.system("del /f terraform.tfstate")
        #os.system("del /f terraform.tfstate.backup")