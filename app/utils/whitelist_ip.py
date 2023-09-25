import boto3
import urllib.request

if __name__ == '__main__':
    desc = input('Description: ')

    external_ip = urllib.request.urlopen('https://ident.me').read().decode('utf8')

    ec2 = boto3.client('ec2')
    ec2.authorize_security_group_ingress(
        GroupId='sg-b89522df',
        IpPermissions=[
            {
                'FromPort': 3306,
                'IpProtocol': 'tcp',
                'IpRanges': [
                    {
                        'CidrIp': '{}/32'.format(external_ip),
                        'Description': '{}'.format(desc),
                    },
                ],
                'ToPort': 3306,
            },
        ],
    )
