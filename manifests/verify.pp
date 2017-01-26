define bluegreen::verify(
  $nodes,
) {
  notify { $nodes: }
}
Bluegreen::Verify consumes Nodes {}
Bluegreen::Verify produces Dependency {}
