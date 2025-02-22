# (C) Copyright 1996-2016 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

#USAGE (e.g.): python precip3.py EUEupsPr.txt
# The same script can be used for Ups Snowmelt too

from csv import reader
from datetime import *
from Magics.macro import *
from sys import argv

if len(argv) == 2 :
	data = argv[1]
else :
	print "Missing input file name" 
	exit(1)
	
out = data.split(".")[0]


def transform(dates, values) :
	
	d = []
	v = []
	
	# First we calcaulet the step 
	date1= datetime.strptime( dates[1],'%Y-%m-%d %H:%M:00')
	date2= datetime.strptime( dates[2],'%Y-%m-%d %H:%M:00')
	step = date2 - date1
	step = step.total_seconds()
	print "STEP_-> %d" % (step/3600)
	for i in range(0, len(dates)):
		date= datetime.strptime( dates[i],'%Y-%m-%d %H:%M:00')
		d1 = date - timedelta(0,step/2)
		d2 = date  + timedelta(0,step/2)
		d.append(datetime.strftime(d1,'%Y-%m-%d %H:%M:00'))
		d.append(datetime.strftime(d2,'%Y-%m-%d %H:%M:00'))
		v.append(values[i])
		v.append(values[i])
		
		
	return { "dates" : d, "values": v, "step" : step}




#read input file
f= file(data,'rb')
r= reader(f,delimiter=';')
rows= []
for row in r:
	
	if (len(row) == 0 ): continue
	#skip useless lines
	if row[0][0]=='X': continue
	if row[0][0]=='#': continue
	if row[0][0]=='-': continue
	if row[0][0]==' ': continue
	rows+= [row]
f.close()

#limit values
max_date= '0'
min_date= '9'
max_y=    -10000000000
min_y=     10000000000

#dictionary structure
data= {}

data['WB_FOR']= {} 
data['WB_FOR']['DATE']= []
data['WB_FOR']['DWD']=  []
data['WB_FOR']['EUD']=  []

data['WB_OBS']= {} 
data['WB_OBS']['DATE']= []
data['WB_OBS']['OBS']=  []

data['WB_OBS']= {} 
data['WB_OBS']['DATE']= []
data['WB_OBS']['OBS']=  []

data['FOR_DETERMINISTIC']= {} 
data['FOR_DETERMINISTIC']['DATE']= []
data['FOR_DETERMINISTIC']['DWD']=  []
data['FOR_DETERMINISTIC']['EUD']=  []

data['FOR_PROBABILISTIC']= {} 
data['FOR_PROBABILISTIC']['DATE']= []
data['FOR_PROBABILISTIC']['TMIN']= []
data['FOR_PROBABILISTIC']['T25']=  []
data['FOR_PROBABILISTIC']['TMED']= []
data['FOR_PROBABILISTIC']['T75']=  []
data['FOR_PROBABILISTIC']['TMAX']= []

#fill the dictionary
row_type= ''
for row in rows:
	f1= row[0]
	if f1.find('EUE')==0 or f1.find('COS')==0:
		abbr=row[0]
		title=row[1]
		units=row[2]
		row_type= 'IGN'
		continue
	if f1.find('WB_FOR')==0:
		row_type= 'FOR'
		continue
	if f1.find('WB_OBS')==0:
		row_type= 'OBS'
		continue
	if f1.find('FOR_DETERMINISTIC')==0:
		row_type= 'DET'
		continue
	if f1.find('FOR_PROBABILISTIC')==0:
		row_type= 'PRO'
		continue
	if f1.find('THlow')==0:
		data['THlow']=     float(row[0].split('=')[1])
		data['THmedium']=  float(row[1].split('=')[1])
		data['THHigh']=    float(row[2].split('=')[1])
		data['THextreme']= float(row[3].split('=')[1])
		continue
	print row_type
	#convert numbers format
	row= [row[0]]+[float(ele) for ele in row[1:]]
	print row
	print "---"
	if row_type=='FOR':
		date= datetime.strptime(row[0],'%d/%m/%Y %H:%M')
		row[0]= datetime.strftime(date,'%Y-%m-%d %H:%M:00')
		data['WB_FOR']['DATE']+= [row[0]]
		data['WB_FOR']['DWD']+=  [row[1]]
		data['WB_FOR']['EUD']+=  [row[2]]
	if row_type=='OBS':
		date= datetime.strptime(row[0],'%d/%m/%Y %H:%M:%S %p')
		row[0]= datetime.strftime(date,'%Y-%m-%d %H:%M:%S')
		data['WB_OBS']['DATE']+= [row[0]]
		data['WB_OBS']['OBS']+=  [row[1]]
	if row_type=='DET':
		date= datetime.strptime(row[0],'%d/%m/%Y %H:%M')
		row[0]= datetime.strftime(date,'%Y-%m-%d %H:%M:00')
		data['FOR_DETERMINISTIC']['DATE']+= [row[0]]
		data['FOR_DETERMINISTIC']['DWD']+=  [row[1]]
		data['FOR_DETERMINISTIC']['EUD']+=  [row[2]]
	if row_type=='PRO':
		date= datetime.strptime(row[0],'%d/%m/%Y %H:%M')
		row[0]= datetime.strftime(date,'%Y-%m-%d %H:%M:00')
		data['FOR_PROBABILISTIC']['DATE']+= [row[0]]
		data['FOR_PROBABILISTIC']['TMIN']+= [row[1]]
		data['FOR_PROBABILISTIC']['T25']+=  [row[2]]
		data['FOR_PROBABILISTIC']['TMED']+= [row[3]]
		data['FOR_PROBABILISTIC']['T75']+=  [row[4]]
		data['FOR_PROBABILISTIC']['TMAX']+= [row[5]]
	if row_type=='IGN':
		date = datetime.strptime(row[0],'%d/%m/%Y %H:%M')
		base=datetime.strftime(date,'%Y-%m-%d %H:%M:00')
		print "base" + base
		row[0]= datetime.strftime(date,'%Y-%m-%d %H:%M:00')
		
		
	#calculate range of dates
	if ( max_date == '0') : 
		date1 = datetime.strptime(row[0],'%Y-%m-%d %H:%M:00')
	else :
		date1 = datetime.strptime(max_date,'%Y-%m-%d %H:%M:00')
	
	date2 = datetime.strptime(row[0],'%Y-%m-%d %H:%M:00')
	date = max(date1,date2)
	
	max_date = datetime.strftime(date,'%Y-%m-%d %H:%M:00')
	#calculate range of dates
	if ( min_date == '9') : 
		date1 = datetime.strptime(row[0],'%Y-%m-%d %H:%M:00')
	else :
		date1 = datetime.strptime(min_date,'%Y-%m-%d %H:%M:00')
	
	
	date= min(date1,date2)
	min_date = datetime.strftime(date,'%Y-%m-%d %H:%M:00')
	
	#do not use missing values when calculating extreme values
	values= [ele for ele in row[1:] if ele!=1.7e+308]
	max_y=    max([max_y]+values)
	min_y=    min([min_y]+values)

#################################################################
#test
#for key in data:
	#obj= data[key]
	#if type(obj)==type({}):
	#	for k2 in obj: print key,k2,obj[k2]
	#else:
	#	print key, obj
#print 'limits values:'
#print 'x:',[min_date,max_date]
#print 'y:',[min_y,max_y]
#################################################################


output = output(output_formats=['png'],
                output_name_first_page_number='off',
                output_name=out)

min = 0.
max = round(max_y + ((max_y-min_y)*0.1))
step1= datetime.strptime(data['FOR_DETERMINISTIC']['DATE'][1], '%Y-%m-%d %H:%M:00')
step2= datetime.strptime(data['FOR_DETERMINISTIC']['DATE'][2], '%Y-%m-%d %H:%M:00')
last= datetime.strptime(max_date, '%Y-%m-%d %H:%M:00')
last = last+ (step2-step1)/2
max_date = datetime.strftime(last, '%Y-%m-%d %H:%M:00')


print title

width = 27.
height =  (2*width)/5


# Now we add 

# Setting the cartesian view
projection = mmap(
	super_page_x_length=width+3,
	super_page_y_length = height+4,
    subpage_x_position=2.2,
	subpage_y_position=2.8,
	subpage_x_length= width,
	subpage_y_length= height,
    subpage_map_projection='cartesian',
    subpage_x_axis_type='date',
    subpage_y_axis_type='regular',
    subpage_x_date_min=min_date,
    subpage_x_date_max=max_date,
    subpage_y_min=min,
    subpage_y_max=max,
    page_id_line="off",
    )

# Vertical axis
vertical = maxis(
    axis_orientation='vertical',
    axis_type='regular',
    axis_tick_label_height=0.70,
    axis_tick_label_colour='navy',
    axis_grid='on',
    axis_grid_colour='grey',
    axis_grid_thickness=1,
    axis_grid_line_style='dot',
    axis_title='on',
	axis_title_text=title + "[" + units + "]",
    axis_title_height=0.7,
	#axis_title_font_style='bold',
    )

# Horizontal axis
horizontal = maxis(
    axis_orientation='horizontal',
    axis_type='date',
    axis_grid='on',
	axis_days_sunday_label_colour='black',
    axis_days_label_height=0.50,
    axis_days_label_position=0,
    axis_months_label_height=0.50,
    axis_years_label_height=0.50,
    axis_grid_colour='grey',
    axis_grid_thickness=1,
    axis_grid_line_style='dot',
    axis_title='on',
	axis_title_text='Date',
	axis_title_height=0.7,
    #axis_title_font_style='bold',
    )

input = transform(data['FOR_DETERMINISTIC']['DATE'], data['FOR_DETERMINISTIC']['DWD'])

# dwd black curve
dwd_input = minput(input_x_type='date',
                   input_date_x_values=input["dates"],
                   input_y_values=input["values"])

dwd_plot = mgraph(
	graph_line_colour='black',
	graph_line_thickness=3,
	legend='on',
	legend_user_text="DWD")

input = transform(data['FOR_DETERMINISTIC']['DATE'], data['FOR_DETERMINISTIC']['EUD'])

# eud red curve
eud_input = minput(input_x_type='date',
                   input_date_x_values=input["dates"],
                   input_y_values=input["values"])

eud_plot = mgraph(
	graph_line_colour='red',
	graph_line_thickness=3,
	legend='on',
	legend_user_text="ECMWF")


input = transform(data['FOR_PROBABILISTIC']['DATE'], data['FOR_PROBABILISTIC']['TMED'])



t75_25_input = minput(input_x_type='date',
  input_date_x_values = data['FOR_PROBABILISTIC']['DATE'],
  input_date_x2_values = data['FOR_PROBABILISTIC']['DATE'],
  input_y_values = data['FOR_PROBABILISTIC']['T75'],
  input_y2_values = data['FOR_PROBABILISTIC']['T25'],
)

t75_25_graph = mgraph(graph_type = "bar",
  graph_bar_line_colour='rgb(0.6980392,0.7450980,0.8980392)',
  graph_bar_width= input["step"],
  graph_shade_colour = "rgba(0.6980392,0.7450980,0.8980392,0.8)",
  legend='on',
   legend_user_text= abbr + "25%-75%"
  
)
tmax_min_input = minput(input_x_type='date',
  input_date_x_values = data['FOR_PROBABILISTIC']['DATE'],
  input_date_x2_values = data['FOR_PROBABILISTIC']['DATE'],
  input_y_values = data['FOR_PROBABILISTIC']['TMAX'],
  input_y2_values = data['FOR_PROBABILISTIC']['TMIN'],
)

tmax_min_graph = mgraph(graph_type = "bar",
  graph_bar_line_colour='rgb(0.8980392,0.8980392,1)', 
  graph_bar_width= input["step"],
  graph_shade_colour = "rgba(0.8980392,0.8980392,1,0.6)",
  legend='on',
  legend_user_text= abbr + " 0%-100%"
  
)





# Median curve

med_input = minput(input_x_type='date',
                   input_date_x_values=input["dates"],
                   input_y_values=input["values"])

med_plot = mgraph(
	graph_line_colour='rgb(0.30,0.50,1.00)',
	graph_line_thickness=3,
	legend='on',
	legend_user_text= abbr + " 50%",
	)

legend= mlegend(legend='on',
				legend_text_colour='black',
				legend_text_font_size=0.7,
				legend_box_mode = "positional",
				legend_box_x_position = 1.00,
				legend_box_x_length=30.,
				legend_box_y_length=1.,
				legend_entry_text_width =80.,
				)
plot(output, projection, vertical, horizontal, 
	  tmax_min_input, tmax_min_graph,
	  t75_25_input, t75_25_graph,
	  med_input, med_plot,
      eud_input, eud_plot,
      dwd_input, dwd_plot,
	  legend
	)	
