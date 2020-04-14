#!/usr/bin/env python

import json
import os
from io import BytesIO
import boto3
import datetime
import pandas as pd


# AWS Credentials <TODO CREATE PUBLIC KEY FOR AWS CREDENTIALS>
myKey = # '<MyKey>'
mySecret = # '<MySecret>'

class ordersPipeline():
	
	bucket = # '<MyBucketName>'
	s3_directory = # 's3://<BucketName>/<File>/'

	@property
	def s3(self):
		return boto3.client('s3', aws_access_key_id=myKey, aws_secret_access_key=mySecret)

	def loadAllJSONFromS3(self):
		prefix = 'data/'
		suffix = '.json'
		response = self.s3.list_objects_v2(Bucket=self.bucket, Prefix=prefix)
		files_written = []
		all_orders = []

		for s3_file in response['Contents']:
			file_name = s3_file['Key']
			
			# Get all JSON files from folder
			if file_name.endswith(suffix):
				print "Reading JSON from S3: " + file_name

				obj = self.s3.get_object(Bucket=self.bucket, Key=file_name)
				json_data = json.load(obj['Body'])
				orders_json_list = json_data['orders']

				# Create combined CSV
				for order in orders_json_list:
					print len(all_orders)
					all_orders.append(order)

		self.formatFileForS3(all_orders, 'all_orders.csv')
					

	def formatFileForS3(self, orders_json_list, file_name):
		df = pd.DataFrame(orders_json_list)
		csv_buffer = BytesIO()
		df.to_csv(csv_buffer, index = False, line_terminator='\n')
		s3_resource = boto3.resource('s3')
		s3_resource.Object(self.bucket, 'output/' + file_name).put(Body=csv_buffer.getvalue())

if __name__ == '__main__':
	pipeline = ordersPipeline()
	pipeline.loadAllJSONFromS3()