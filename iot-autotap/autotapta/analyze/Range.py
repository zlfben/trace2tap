from autotapta.model.Trace import Trace
from autotapmc.channels.template.DbTemplate import template_dict as default_template_dict
from autotapta.analyze.Cluster import findKRange
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from numpy import array, around


def reAssignRangeVariableInTrace(trace: Trace, template_dict=default_template_dict):
    value_dict = dict()
    for cap in trace.system.state_dict.keys():
        dev, var = cap.split('.')
        typ = template_dict[dev][var]
        if typ.startswith('numeric') and 'external' not in typ:
            value_dict[cap] = []

    # step 1: put all possible values into vectors
    field_names = trace.system.getFieldNameList()
    for fn, val in zip(field_names, trace.initial_state):
        if fn in value_dict:
            value_dict[fn].append(val)
    
    for _time, action in trace.actions:
        cap, val = action.split('=')
        if cap in value_dict:
            value_dict[cap].append(float(val))

    # step 2: calculate clusters using k-means
    center_value_dict = dict()
    kmeans_dict = dict()
    for key, value_list in value_dict.items():
        value_list = array(value_list).reshape(-1,1)
        n_c = findKRange(value_list)
        # print('============best n_cluster for %s: %d (%d entries)' % (key, n_c, len(value_list)))
        kmeans = KMeans(n_clusters=n_c).fit(value_list)
        center_value_dict[key] = list(around(kmeans.cluster_centers_.reshape(1,-1)[0], decimals=2))
        kmeans_dict[key] = kmeans
    
    # step 3: change values in the trace
    for fn, index in zip(field_names, range(len(field_names))):
        if fn in kmeans_dict:
            cluster = kmeans_dict[fn].predict([[trace.initial_state[index]]])[0]
            trace.initial_state[index] = float(center_value_dict[fn][cluster])
    
    for pre_cond in trace.pre_condition:
        for fn, index in zip(field_names, range(len(field_names))):
            if fn in kmeans_dict:
                cluster = kmeans_dict[fn].predict([[pre_cond[index]]])[0]
                pre_cond[index] = float(center_value_dict[fn][cluster])
    
    for index in range(len(trace.actions)):
        _time, action = trace.actions[index]
        cap, val = action.split('=')
        if cap in kmeans_dict:
            cluster = kmeans_dict[cap].predict([[float(val)]])[0]
            new_val = float(center_value_dict[cap][cluster])
            new_action = '%s=%s' % (cap, str(new_val))
            trace.actions[index] = (_time, new_action)

    return trace
    