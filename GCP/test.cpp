//
//     2
//    / \
//   /   \
//  5     1  +4
// (7)   /|\
// +0   / | \
//     2  1  2
//    (5)(4)(5)
//    +2  +3 +2


struct TreeNode {
  int node_exec_time;   // Exec time, e.g 2
  int total_exec_time;  // From the root to the node, e.. 2 + 5
  int delay;            // Max delay - total_exec_time
  unordered_set<TreeNode*> children_; // int - id
  TreeNode (int v, vector<int> children) {
    value = v;
    for (int &el: children) {
      TreeNode* node = new TreeNode(el, /* children of children */);
      children_.insert(node);
    }
  }
}

// new TreeNode(2, {new TreeNode(5, {}), new TreeNode(1, {...})}

class Factory {
  max_delay = 0;
  TreeNode* root;

  public:
    // Initialize tree

    // Get max delay - Done
    get_max_delay (root);

    // Calculate delay per node

  private:
    set_max_delay(TreeNode* root) {
      dfs_get_max_delay (root, 0);
    }

    dfs_set_max_delay (TreeNode* cur, int delay) {  // Do we need a return value from dfs?
      int cur_delay = delay + cur->node_exec_time;
      cur->total_exec_time = cur_delay;
      max_delay = max(max_delay, cur_delay);

      if (cur->children.empty()) {
        return;
      }
      for (auto &child: children) {
        dfs_set_max_delay(child, cur_delay);
      }
    }

    dfs_set_delay_per_child(TreeNode* node) {
      if (cur->children.empty()) {
        node->delay = max_delay - total_exec_time;
        return;
      }
      for (auto &child: children) {
        dfs_set_delay_per_child(child);
      }
    }
}
