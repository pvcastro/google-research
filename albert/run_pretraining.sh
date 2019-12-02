#!/usr/bin/env bash

# Read data_text_dir path from a config file.
CURDIR=$(cd $(dirname $0); pwd)
source <(sed -n '/^\[DATA\]/,/^\[/p' ${CURDIR}/config.ini | grep TEXTDIR | sed 's/ *= */=/g')
echo ${TEXTDIR}

source <(sed -n '/^\[DATA\]/,/^\[/p' ${CURDIR}/config.ini | grep MODELDIR | sed 's/ *= */=/g')
echo ${MODELDIR}

source <(sed -n '/^\[DATA\]/,/^\[/p' ${CURDIR}/config.ini | grep CHECKPOINTDIR | sed 's/ *= */=/g')
echo ${CHECKPOINTDIR}


MAX_SEQ_LEN=512
TRAIN_BATCH_SIZE=4096

python -m albert.run_pretraining \
   --albert_config_file "${CURDIR}/albert_config.json" \
   --input_dir ${TEXTDIR} \
   --output_dir ${CHECKPOINTDIR} \
   --export_dir ${MODELDIR} \
   --do_train \
   --do_eval \
   --train_batch_size ${TRAIN_BATCH_SIZE} \
   --max_seq_length ${MAX_SEQ_LEN} \
#   --max_predictions_per_seq 20 \
#   --num_train_steps 1000000 \
#   --num_warmup_steps 10000 \
#   --save_checkpoints_steps 10000 \
#   --learning_rate 1e-4