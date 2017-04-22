import itertools
import matplotlib.pyplot as plt

def parse_ip_addr(ip_str):
    splitted = ip_str.split('.')
    return (
        int(splitted[0]),
        int(splitted[1]),
        int(splitted[2]),
        int(splitted[3])
    )

def split_range_to_class_c(start_ip, end_ip):
    if start_ip[0] != end_ip[0]:
        raise 'Not support {} - {}'.format(start_ip, end_ip)

    if start_ip[1] != end_ip[1]:
        start_range = split_range_to_class_c(start_ip, [start_ip[0], start_ip[1], 255, 0])
        between_range = list(itertools.chain(*[
            split_range_to_class_c([start_ip[0], i, 1, 0], [start_ip[0], i, 255, 0])
            for i in range(start_ip[1] + 1, end_ip[1])
        ]))

        end_range = split_range_to_class_c([end_ip[0], end_ip[1], 0, 0], end_ip)
        return list(itertools.chain(start_range, between_range, end_range))
    if start_ip[2] == end_ip[2]:
        return [start_ip]

    return [
        (start_ip[0], start_ip[1], i, 0)
        for i in range(start_ip[2], end_ip[2] + 1)
    ]


def mask_to_class_c(ip_addr):
    return (ip_addr[0], ip_addr[1], ip_addr[2], 0)

def format_ip_addr(ip_addr):
    return '{}.{}.{}.{}'.format(*ip_addr)

def plot_bar(label, data):
    """
    Plot a bar graph with one serie.
    param label: list of label (any type)
    param data: list of data (number only). Its length should be match with label
    """
    x_values = range(len(label))

    plt.bar(x_values, data, 0.5)
    plt.xticks(list(map(lambda x: x, x_values)), label)

def stack_line(label, datum):
    x_values = range(len(label))

    def accumulate_arr(acc, i):
        return [x + y for x, y in zip(acc, i)]

    y_values = itertools.accumulate(datum, accumulate_arr)

    for ys in y_values:
        plt.plot(x_values, list(ys))

    plt.xticks(x_values, label)
