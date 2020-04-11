# AWS Key Management Service (KMS)

> AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. AWS KMS is a secure and resilient service that uses hardware security modules that have been validated under FIPS 140-2, or are in the process of being validated, to protect your keys. AWS KMS is integrated with AWS CloudTrail to provide you with logs of all key usage to help meet your regulatory and compliance needs.

[AWS Key Management Service (KMS)](https://aws.amazon.com/kms/)

## Variables

*key_admin*: Key administrator username

*key_user*: Key user username

## Resources

**KMS Key**

**KMS Alias**

## Commands

**Encryption / Decryption Example**

Excryption

```
aws kms encrypt \
  --key-id  alias/aws-kms \
  --plaintext fileb://hello.txt \
  --output text \
  --query CiphertextBlob | \
  base64 \
  --decode > \
  hello-encrypted.bin
```

Decryption

```
aws kms decrypt \
  --ciphertext-blob fileb://hello-encrypted.bin \
  --output text \
  --query Plaintext | \
  base64 \
  --decode > \
  hello-decrypted.txt
```

**Data Key Example**

Generate Data Key

```
aws kms generate-data-key \
  --key-id alias/aws-kms \
  --key-spec AES_256 > \
  data-key.json
```

Extract Data Key from JSON (Base 64 Encoded)

```
echo "3mQInAUpWXS9JQwjh0OH8TMfK8CKVe6ZkjeRahLzlwo=" | \
openssl base64 \
-d > \
plaintext_key_decoded
```

Encrypt File Using Data Key

```
openssl enc \
  -e \
  -aes256 \
  -kfile plaintext_key_decoded \
  -in hello.txt \
  -out hello-data-key-encrypted.bin
```

Obtain Data Key from KMS Using Encrypted Data Key from JSON

```
aws kms decrypt \
  --ciphertext-blob "AQIDAHiZ5FHa8awHvx35tlP/29CLGD3rdjkAKYI/kKgaWhRHggHWx3NLFD1DPXFYvVUdWY4JAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMJkX+ov4sfKP2ftmWAgEQgDsK6oH0P0EQaB5U0t55JgFyXyX0ZDWqyTaP+DV4JCtYCvNrPm7VtEv3saBQVTY9WpFnk6YsfsgQ5eNmoA==" \
  --query 'Plaintext' \
  --output text | \
  openssl base64 \
  -d \
  -out plaintext_key_decoded
```

Decrypt File Using Data Key

```
openssl enc \
  -d \
  -aes256 \
  -kfile plaintext_key_decoded \
  -in hello-data-key-encrypted.bin \
  -out hello-data-key-decrypted.txt
```
