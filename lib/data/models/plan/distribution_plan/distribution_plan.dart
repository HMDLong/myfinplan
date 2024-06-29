class DistributionPlan<T> {
  Map<String, T> categoryLevelMap;
  Map<T, int> levelToAmountMap;

  DistributionPlan(this.categoryLevelMap, this.levelToAmountMap);
}
