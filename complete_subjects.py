#Moving subjects with two timepoints to a new directory
import glob
import os.path as op
import shutil

derive_folder = '/home/data/nbc/Laird_PhysicsLearning/dset-v2.0.0/derivatives/idconn-hippocampus_rest/'
subjects = [subject.split('/')[-1] for subject in glob.glob(op.join(derive_folder, '*'))]
complete_subjects = [subject for subject in subjects if len(glob.glob(op.join(derive_folder, subject, '*'))) == 2]
complete_subjects = sorted(complete_subjects)
complete_subjects_folder = '/home/data/nbc/Laird_PhysicsLearning/dset-v2.0.0/derivatives/idconn-hippocampus_rest_complete_data/'
for subject in complete_subjects:
    target_folder = op.join(derive_folder,subject)
    copy_folder = op.join(complete_subjects_folder,subject)
    shutil.copytree(target_folder, copy_folder)

