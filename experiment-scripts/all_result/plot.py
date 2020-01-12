import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib.font_manager as font_manager


#plt.rcParams['font.family'] = ['Times New Roman']
plt.rcParams.update({'font.size': 22}) 
plt.rcParams.update({'figure.autolayout': True})


#store file names
fname = ["tpcbih","employee","multiset"]
#the column in .csv file (each column one line)
num_range = ["PG-Seq","PG-Nat"]
l_color = ["Deepskyblue","Red"]

path_dir = "/reproducibility/experiment-scripts/result/"

plt.figure(figsize=(8,5)) 
for f in range(len(fname)):
    #current file name
    cur_fn = fname[f]
    #read data to pop
    pop = pd.read_csv(path_dir + cur_fn + ".csv")
    width = 0.2  
    N = len(pop['Query'])
    x1 = np.arange(N)
    for i in range(len(num_range)):
        y1 = pop[num_range[i]]
        #if(f==0):
        plt.bar(x1+width*i, y1, width, alpha=0.5, label=num_range[i],color=l_color[i],bottom=0.01)
        plt.yscale("log",basey=10)
        plt.legend(loc='best',prop={'size': 18}, ncol=2)
        if(f==0):
            plt.xticks(x1+width*i, ('Q1','Q5','Q6','Q7','Q8','Q9','Q12','Q14','Q19'))
            #plt.legend(loc=8,ncol=2,prop={'size': 6})
        elif(f==1):
            plt.xticks(x1+width*i, ('join1','join2','join3','join4','agg1','agg2','agg3','agg-join','diff1','diff2'))
        elif(f==2):
            plt.xticks(x1+width*i, ('1k','10k','100k','300k','500k','1000k','3000k'))

    plt.ylabel('Runtime',fontsize=30)
    plt.tick_params(axis='x', which='major', labelsize=14)
    plt.tick_params(axis='y', which='major', labelsize=14)

    #save each plot to pdf
    print (cur_fn + ".pdf")
    #plt.savefig("./" + cur_fn + ".pdf",dpi=600,format='pdf');
    plt.savefig("./" + cur_fn + ".pdf",format='pdf');
    #clean current plot data
    plt.clf();
