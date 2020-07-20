from kmodes.kmodes import KModes
from numpy import array
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score


def findK(value_list, max_clusters=5, metric="euclidean", clusterer="kmeans"):
    value_list_temp = [tuple(list(x)) for x in value_list]
    value_set_temp = set(value_list_temp)
    max_clusters = max_clusters if max_clusters < len(value_set_temp) else len(value_set_temp)
    if max_clusters <= 1:
        return max_clusters
    n_cluster_list = list(range(2, max_clusters + 1))
    score_list = []
    for n_cluster in n_cluster_list:
        if clusterer == "kmeans":
            kmeans = KMeans(n_cluster)
        elif clusterer == "kmodes":
            kmeans = KModes(n_cluster)
        else:
            raise Exception("Unknown clusterer %d" % clusterer)
        labels = kmeans.fit_predict(value_list)
        silhouette_avg = silhouette_score(value_list, labels, metric=metric)
        score_list.append(silhouette_avg)
    max_score = max(score_list)
    max_index = score_list.index(max_score)
    return n_cluster_list[max_index]


def findKRange(data, max_clusters=5):
    return findK(data, max_clusters)


def findKBitVec(data, max_clusters=5):
    return findK(data, max_clusters, "hamming", "kmodes")


def clusterBitVec(data, max_clusters=5):
    best_k = findKBitVec(data, max_clusters)
    if best_k == 0:
        return 0, []
    else:
        kmodes = KModes(best_k)
        labels = kmodes.fit_predict(data)
        return best_k, labels


def clusterRangeVars(data, max_clusters=5):
    """
        return besk_k, centers, labels
    """
    best_k = findKRange(data)
    if best_k == 0:
        return 0, [], []
    else:
        kmeans = KMeans(best_k)
        labels = kmeans.fit_predict(data)
        centers = kmeans.cluster_centers_
        return best_k, centers, labels