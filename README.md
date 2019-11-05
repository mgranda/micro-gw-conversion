# micro-gw-conversion
Example conversion SOAP/REST WSO2 microgateway number to dollars

**Configuration**
export MGW_TOOLKIT_HOME=/opt/wso2am-micro-gw-toolkit-3.0.2
export MGW_RUNTIME_HOME=/opt/wso2am-micro-gw-linux-3.0.2
export BALLERINA_HOME=/usr/lib/ballerina/ballerina-1.0.1/bin
export JAVA_HOME=/home/jgranda/.sdkman/candidates/java/current
export PATH=$PATH:$MGW_TOOLKIT_HOME/bin:$MGW_RUNTIME_HOME/bin:$JAVA_HOME/bin

**WSO2 Microgateway**
micro-gw build micro-gw-conversion
gateway micro-gw-conversion.balx

**Docker**
docker run -d -p 9090:9090 -p 9095:9095 conversion:v1