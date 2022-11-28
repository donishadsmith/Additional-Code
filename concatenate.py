#Concatenatinf files for subjects
import glob
import os.path as op
import pandas as pd

complete_subjects_folder = '/home/data/nbc/Laird_PhysicsLearning/dset-v2.0.0/derivatives/idconn-hippocampus_rest_complete_data/'
subjects = [subject.split('/')[-1] for subject in glob.glob(op.join(complete_subjects_folder, '*'))]
sessions = ['ses-1', 'ses-2']

for subject in subjects:
    subject_dir = op.join(complete_subjects_folder, f'{subject}')
    for session in sessions:
        complete_dir = op.join(subject_dir, f'{session}','func')
        confound_df = pd.read_csv(glob.glob(op.join(complete_dir,'*confounds_timeseries.tsv' ))[0], sep = '\t')
        timeseries_df = pd.read_csv(glob.glob(op.join(complete_dir, '*hippocampus_desc-timeseries_bold.tsv'))[0], sep = '\t')
        concatenated_df = pd.concat([timeseries_df,confound_df], axis = 1)
        concatenated_file = op.join(complete_dir, f'{subject}_{session}_task_rest_space-MNI152NLin2009cAsym_atlas-hippocampus_desc-concatenated_timeseries_and_confounds.tsv')
        concatenated_df.to_csv(concatenated_file, sep='\t')
        