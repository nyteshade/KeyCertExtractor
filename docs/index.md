## Introduction
The KCE, or KeyCertExtractor tool, is a small tool born out of frustration when dealing with SSL certs and implementing them with your various websites. SSL Cert vendors deliver cert files in different manners and various formats. This tool attempts to normalized those things.

Overall, this is a hacked together GUI tool for extracting a cert file and private key from a given SSL .pfx file. The application takes a locally existing .pfx file or .p12 file and, using the /usr/bin/openssl command, will extract the private key and PEM certificate for you as long as you know the passphrase.

![Screenshot](https://github.com/nyteshade/KeyCertExtractor/raw/master/screenshots/running.png)


## Usage
 - Double click the application
 - Drag your PFX/P12 file on top of the Path to PEM/PFX text field (*this will copy the path*)
 - Enter your passphrase
 - Click on either the Extract PEM Certificate or Extract Private Key buttons to get the desired file out of the encrypted PFX/P12 file you supplied.
   - **NOTE** The output file name will be the same as the source with a different extension; .key for the private key and .pem for the certificate
   
 ## How do I use these with Express 4.x or node-spdy?
 When constructing the options object, simply use the contents of these files as the values for `cert` and `key`, respectively.
 
 ```js
 {
   cert: fs.readFileSync('/path/to/file.pem').toString(),
   key: fs.readFileSync('/path/to/file.key').toString()
 }
 ```
